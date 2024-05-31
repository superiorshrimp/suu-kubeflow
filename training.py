import os
import evaluate
import numpy as np
from datasets.distributed import split_dataset_by_node
from transformers import (
  AutoTokenizer,
  AutoModelForSequenceClassification,
  DataCollatorWithPadding,
  Trainer,
  TrainingArguments,
)

from datasets import (
    load_dataset
)


def preprocess_dataset(examples):
    _input = [f"{qt} {qc}? {ba}" for qt, qc, ba in zip(examples["question_title"], examples["question_content"], examples["best_answer"])]
    _tokenized = tokenizer(_input, truncation=True, padding=False)
    return {"input_ids": _tokenized["input_ids"], "attention_mask": _tokenized["attention_mask"], "labels": examples["topic"]}


def compute_metrics(eval_pred):
    logits, labels = eval_pred
    predictions = np.argmax(logits, axis=-1)
    return metric.compute(predictions=predictions, references=labels)


model_name = "FacebookAI/roberta-large"
dataset_name = "yahoo_answers_topics"

metric = evaluate.load("accuracy")

print("-" * 40)
print("Download dataset")
dataset = load_dataset(dataset_name, split="train[:20%]")
label_names = dataset.features['topic'].names
id2label = dict(enumerate(label_names))
label2id = {label: i for i, label in id2label.items()}

print("-" * 40)
print("Create model, tokenizer & data collator")
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(model_name,
                                                          num_labels=len(label_names),
                                                          id2label=id2label,
                                                          label2id=label2id,)

collator = DataCollatorWithPadding(tokenizer, padding='longest')

print("-" * 40)
print("Preprocess dataset")

tokenized_dataset = dataset.map(preprocess_dataset, batched=True, remove_columns=["id", "topic", "question_title", "question_content", "best_answer"])

train_validation = tokenized_dataset.train_test_split(test_size=0.1, seed=0)

ready_dataset = datasets.DatasetDict({
    "train": train_validation['train'],
    "validation": train_validation['test'],
    "test": load_dataset(dataset_name, split="test[:5%]").map(preprocess_dataset, batched=True, remove_columns=["id", "topic", "question_title", "question_content", "best_answer"]),
})

RANK = int(os.environ["RANK"])
WORLD_SIZE = int(os.environ["WORLD_SIZE"])
distributed_ds_train = split_dataset_by_node(
    ready_dataset["train"],
    rank=RANK,
    world_size=WORLD_SIZE,
)
distributed_ds_eval = split_dataset_by_node(
    ready_dataset["validation"],
    rank=RANK,
    world_size=WORLD_SIZE,
)
trainer = Trainer(
model=model,
args=TrainingArguments(
    output_dir='models-roberta',
    evaluation_strategy='epoch',
    save_strategy='epoch',
    learning_rate=2e-5,
    per_device_train_batch_size=8,
    per_device_eval_batch_size=8,
    num_train_epochs=2,
    weight_decay=0.01,
    metric_for_best_model='f1',
    load_best_model_at_end=True,
    report_to='none',
    log_level="info",
    disable_tqdm=True
),
train_dataset=distributed_ds_train,
eval_dataset=distributed_ds_eval,
tokenizer=tokenizer,
data_collator=collator,
compute_metrics=compute_metrics,
)

print("-" * 40)
print(f"Start model training. RANK: {RANK} WORLD_SIZE: {WORLD_SIZE}")

trainer.train()

print("-" * 40)
print("Training complete")