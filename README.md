# Kubeflow

<p align="center">
  <img src="img/logo/kubeflow.png" width="256" />
  <img src="img/logo/aws.png" width="256" /> 
</p>

### Zespół
grupy: 2 i 5, rok 2024
 - Antonina Kuś - konfiguracja Kubeflow
 - Szymon Paszkiewicz - infrastruktura AWS
 - Jędrzej Ziebura - modele AI
 - Szymon Żychowicz - dokumentacja, dashboard

### Tematyka
W dobie rosnącej popularności sztucznej inteligencji oraz coraz większej złożoności modeli rośnie zapotrzebowanie na moc obliczeniową. Aby ją osiągnąć można polepszać komponenty komputera, ale można także wykorzystać infrastrukturę rozproszoną. Jest to znacznie efektywniejsze środowisko. Kubeflow i AWS są technologiami będącymi odpowiedzią na to zapotrzebowanie.

### Technologia realizacji
**Kubeflow** służy do wdrażania i wykorzystywania modeli sztucznej inteligencji i uczenia maszynowego w prostym, przenośnym, skalowalnym, rozproszonym środowisku. Wszędzie gdzie używany jest Kubernetes łatwo można zaaplikować Kubeflow.\
\
Pomimo tego, że większość komponentów opiera swoje działanie na Pythonie i YAMLu, konkretna technologia zastosowana w projekcie zależeć będzie od wybranego komponentu, który będzie prezentowany. Przykładowo Kubeflow Pipelines (KFP) oparte są o Pythonowe SDK, konfiguracja Notebooks wykorzystuje Kubeflow GUI i YAMLe pliki konfiguracyjne, natomiast Kubeflow Training Operator (KTO) może korzystać ze znanych bibliotek MLowych tj. transformers, PyTorch lub DeepSpeed.\
\
Jako środowisko chmurowe zespół wykorzysuje **AWS**, który jest bogato wspierany przez kontrybutorów Kubeflow. W sieci dostępne jest dużo wsparcia dla tego rozwiązania przez jego popularność.

### Komponenty

##### KF Pipelines `stable`
Kubeflow Pipelines (KFP) to platforma służąca budowaniu i wdrażaniu przenośnych i skalowalnych MLowych serwisów (workflows) za pomocą Dockerowych kontenerów. Jej dwa główne elementy, komponenty i pipeline’y, można stworzyć za pomocą Pythonowego SDK, a następnie skompilować je do pośredniej, YAMLowej reprezentacji co zapewnia przenośność rozwiązania. Tak zapisany workflow można zlecić do wykonania backendowi wspierającemu KFP, np. open source KFP backend lub Google Cloud Vertex AI Pipelines. Pierwszy z nich jest dostępny zarówno jako jedna z głównych funkcjonalności Kubeflow oraz jako osobna usługa.

##### KF Notebooks `stable`
Kubeflow Notebook to platforma umożliwiająca tworzenie serwerów hostujących Jupyter Notebooki. Pozwala ona na konfiguracje poszczególnych serwerów i udostępnianiu ich publicznie.

##### KF Dashboards `stable`
Dashboards jest komponentem umożliwiającym monitorowanie stanu Kubeflow. Umożliwia on tworzenie odpowiednich widoków, możliwych do skonfigurowania według preferencji użytkownika. Pozwala to na stworzenie pojedynczej strony z wszystkich istotnymi informacjami takimi jak logi, informacje o pipelinach, czy metryki informujące o aktualnym wykorzystaniu zasobów obliczeniowych.

##### KF Katib - AutoML `beta`
AutoML jest komponentem w wersji beta służącym do finetuningu parametrów modelu.
![AutoML](img/architecture/automl.png)

##### KF Kubeflow Training Operator - Model Training `stable`
Model Training jest platformą do trenowania modeli sztucznej inteligencji w środowisku rozproszonym. Umożliwia ona szkolenie modelu z wykorzystaniem takich frameworków jak PyTorch, czy TensorFlow. Udostępnia przy tym takie funkcjonalności jak określenie strategii nauki modelu w systemie rozproszonym, czy chociażby job scheduling.
![KTO](img/architecture/kto.png)

##### KF KServe `stable`
Jest platformą do wdrażania wytrenowanych modeli sztucznej inteligencji bazujący na istniejących już technologiach takich jak TFServing czy Triton Inference Server. W dodatku pokrywa on takie funkcjonalności jak logowanie, autoskalowanie, zapewnia authZ i authN, udostępnia metryki, pozwala na kontrolowanie ruchu z wykorzystaniem firewalli.

##### AWS EKS
Amazon Elastic Kubernetes Service jest usługą zapewniającą wsparcie dla Kubernetesa. Wyręcza administratora z dużej części pracy nad instalacją i utrzymaniem Kubernetesowej platformy.

##### AWS EC2
Amazon Elastic Compute Cloud pozwala na wypożyczanie wirtualnych maszyn na podstawie obrazu AMI. Wykorzystuje się je do uruchamiania na nich aplikacji. 

##### AWS Terraform
Usługa ma za zadanie ułatwienie zarządzanie innymi komponentami AWS. Niesie wiele korzyści automatyzując proces stawiania aplikacji oraz wdrażania zmian redukując czynnik ludzki co ogranicza błędy. Wykorzystuje koncept IaC.

##### AWS VPC
Amazon Virtual Private Cloud służy do logicznego podziału zarządzanej infrastruktury. Umożliwia utworzenie architektury sieciowej przypominającej tradycyjnie używanej lokalnie (niechmurowo).

##### AWS S3
Amazon Simple Storage Service znany jako S3 jest serwisem zapewniającym dostęp do skalowanej, persystentnej pamięci o wysokiej dostępności w chmurze.

### Koncepcja rozważanego przypadku użycia
Wykorzystanie systemu można podzielić na 2 fazy. Są to faza trenowania modelu SI oraz jego serwowania. System zapewnia także możliwość śledzenia metryk, co pozwala analizować jego wydajność kiedy ten pracuje.

##### Faza trenowania modelu sztucznej inteligencji
Do trenowania modelu wykorzystany zostanie Kubeflow Trainig Operator. Jest to platforma do trenowania modeli sztucznej inteligencji w środowisku rozproszonym.
Pozwala wykorzystać zasoby Kubernetesa do efektywnego treningu poprzez Kubernetes Custom Resources APIs.

W naszym projekcie zostanie wykorzystany framework PyTorch wraz z PyTorchJob. Trainig Operator odpowiada za planowanie odpowiednich 
obciążeń Kubernetesa do implementacji różnych strategii szkolenia rozproszonego dla różnych frameworków używanych w uczeniu maszynowym.

Wykorzystay jest do tego algorytm ring all-reduce. To algorytm służący do redukcji wszystkich wartości przetwarzanych 
przez różne węzły klastra do jednej globalnej wartości. Algorytm ten wykorzystuje topologię pierścienia, gdzie dane 
są przesyłane pomiędzy węzłami wzdłuż cyklicznej ścieżki. Każdy węzeł przekazuje swoje dane do sąsiada, który następnie
dokonuje odpowiednich operacji arytmetycznych (na przykład dodawanie) na otrzymanych danych oraz własnych, a następnie
przesyła je dalej. Proces ten kontynuuje się, aż wszystkie węzły otrzymają zaktualizowane dane. Na poniższym diagramie
przedstawiono działanie tego algorytmu we frameworku PyTorch.

<p align="center">
  <img src="img/architecture/pytorchjob.png"/>
</p>




##### Faza serwowania modelu
W celu serwowania modelu wykorzystana zostanie Kserve. Platforma dostarczająca zestaw interfejsów udostępniających model sztucznej inteligencji. 
Bazuje ona na gotowych rozwiązaniach wprowadzanych przez takie biblioteki jak TFServing, TorchServe, czy Triton Inference Server. 
W ramach demo wykorzystany zostanie wcześniej wytrenowany model. Zostanie on wystawiony z wykorzystaniem narzędzi i w pełni obsłużony. 
Pokazane zostanie API powstałe na bazie interfejsów, metryki generowane przez interfejsy oraz możliwe takie funkcjonalności jak AuthZ, AuthN oraz logowanie. 
Ważne przy uwzględnieniu tej fazy jest ilość kodu wygenerowana w trakcie tworzenia infrastruktury oraz przedstawienie dogmatu IaC.

##### Słowo wstępu do modelu i zbioru treningowego
 Kluczową obserwacją w przypadku zbioru danych i modelu, na którym zostanie przeprowadzone demo, jest fakt, że nie są one punktem centralnym projektu,
a jedynie środkiem do pokazania możliwości KFTO i KServe'a, zatem sama jakość wytrenowanego modelu, czy jego adekwatność do danego zadania nie jest szczególnie istotna. Najważniejszym parametrem
zarówno modelu jak i zbioru treningowego jest **wielkość**, ponieważ to ona pozwoli nam uwydatnić zalety Kubeflow.
_________
##### Wybrany model
Niemniej jednak wybrano pasujące do siebie model i zadanie z nadzieją osiągnięcia satrysfakcjonującego wyniku.

Wybranym modelem jest [RoBERTa-large](https://huggingface.co/FacebookAI/roberta-large), czyli model w architekturze transformer w wariancie encoder-only. Posiada on **355 milionów parametrów**, a jego zapis w wersji binarnej waży około **1.43GB**. 
Jego wielkość praktycznie uniemożliwia efektywne trenowanie na pojedynczym CPU, więc dobrze nadaje się do pokazania efektywności Kubeflow.
__________
##### Zbiór treningowy
Ponieważ modele typu encoder-only najlepiej radzą sobie w zadaniach należących do NLU (Natural Language Understanding) takich jak klasyfikacja tokenów (NER, PoS tagging) czy klasyfikacja tekstu (analiza sentymentu, detekcja spamu) zdecydowano się na
wybór zbioru danych umożliwiających wytrenowanie modelu w zadaniu drugiego z wymienionych typów - wieloklasowej klasyfikacji tekstu.

Do tego zadania wybrano zbiór danych [Yahoo anserws topics](https://huggingface.co/datasets/yahoo_answers_topics?row=1), który w zbiorze treningowym posiada aż **1.4 miliona** przykładów. Jest to tak ogromna ilość iż może okazać się, że w projekcie zostanie użyta tylko część zbioru.

Dla ukazania skali zbioru Yahoo, porównajmy go ze  zbiorem [SQuAD v2](https://huggingface.co/datasets/rajpurkar/squad_v2) autorstwa uniwersytetu Stanford, do zadania polegającego na odpowiadania na pytania (ang. question-answering). Uważany za duży zbiór posiada tylko około 130 tysięcy próbek w zbiorze treningowym. Jest zatem prawie 11 razy mniejszy od Yahoo.
________
#### Uzasadanienie wyboru
Aby pokazać, że trening wybranego modelu na powyższym zbiorze danych na pojedyńczym CPU lub GPU jest zadaniem karkołomnym stworzono [demo notebook](showcases/SUU_model_training_showcase.ipynb), gdzie RoBERTę próbujemy trenować na zaledwie 20% zbioru Yahoo.

Poniżej możemy zobaczyć przewidywany czas treningu o długośći dwóch epok (dwukrotne wykorzystanie próbek treningowych) na zasobach platformy Google Colab.

* Przykład na CPU - 2 procesory Intel(R) Xeon(R) CPU @ 2.20GHz - pamięć RAM przepełnia się zanim załaduje się progress bar. Zwykle gdy używamy GPU mówimy o około 10-cio krotnym przyśpieszeniu treningu. Nawet jeśli założymy 8-krotne wydłużenie czasu, otrzymujemy 148H, czyli trochę ponad 6 dni.
* Dla karty T4 GPU, która ma 16GB RAMu praktycznie od razu ta pamięć się przepełnia i otrzymujemy błąd ```OutOfMemoryError: CUDA out of memory```

<p align="center">
  <img src="img/t4_gpu_colab_training.png" width="512" />
  <p align="center">Przykład na GPU - karta graficzna T4 - przewidywany czas treningu &rarr; 18.5H</p>
</p>


### Architektura rozwiązania

### Opis konfiguracji

### Instalacja

### Instrukcja inicjalizacji systemu

### Wdrożenie i użytkowanie demo

### Podsumowanie i wnioski

### Referencje
