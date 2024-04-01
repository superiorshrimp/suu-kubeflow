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
% WSTEP 
% Żymon

##### Faza trenowania modelu sztucznej inteligencji
% Tosia // PYTORCH + TRANSFORMERS

##### Faza serwowania modelu
% Pymon // MODELE NLP

##### Wybrany model
% Jędrzej

##### Zbiór treningowy
% Jędrzej

### Architektura rozwiązania

### Opis konfiguracji

### Instalacja

### Instrukcja inicjalizacji systemu

### Wdrożenie i użytkowanie demo

### Podsumowanie i wnioski

### Referencje
