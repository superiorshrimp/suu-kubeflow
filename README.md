# Kubeflow

<p>
  <img src="img/logo/kubeflow.png" width="256" />
  <img src="img/logo/aws.png" width="256" /> 
</p>

### zespół
 - Antonina Kuś - konfiguracja kubeflow
 - Szymon Paszkiewicz - infrastruktura
 - Jędrzej Ziebura - modele AI
 - Szymon Żychowicz - dokumentacja, dashboard\
**TODO: podział**

### technologia realizacji
**Kubeflow** służy do wdrażania i wykorzystywania modeli sztucznej inteligencji i uczenia maszynowego w prostym, przenośnym, skalowalnym, rozproszonym środowisku. Wszędzie gdzie używany jest Kubernetes łatwo można zaaplikować Kubeflow.\
\
Pomimo tego, że większość komponentów opiera swoje działanie na Pythonie i YAMLu, konkretna technologia zastosowana w projekcie zależeć będzie od wybranego komponentu, który będzie prezentowany. Przykładowo Kubeflow Pipelines (KFP) oparte są o Pythonowe SDK, konfiguracja Notebooks wykorzystuje Kubeflow GUI i YAMLe pliki konfiguracyjne, natomiast Kubeflow Training Operator (KTO) może korzystać ze znanych bibliotek MLowych tj. transformers, PyTorch lub DeepSpeed.\
\
Jako środowisko chmurowe zespół wykorzysuje **AWS**, który jest bogato wspierany przez kontrybutorów Kubeflow. W sieci dostępne jest dużo wsparcia dla tego rozwiązania przez jego popularność.

### tematyka
**TODO: dlaczego potrzebujemy rozwiązań jak kubeflow w dzisiejszych obliczeniach**

### komponenty

##### KF Pipelines `stable`
Kubeflow Pipelines (KFP) to platforma służąca budowaniu i wdrażaniu przenośnych i skalowalnych MLowych serwisów (workflows) za pomocą Dockerowych kontenerów. Jej dwa główne elementy, komponenty i pipeline’y, można stworzyć za pomocą Pythonowego SDK, a następnie skompilować je do pośredniej, YAMLowej reprezentacji co zapewnia przenośność rozwiązania. Tak zapisany workflow można zlecić do wykonania backendowi wspierającemu KFP, np. open source KFP backend lub Google Cloud Vertex AI Pipelines. Pierwszy z nich jest dostępny zarówno jako jedna z głównych funkcjonalności Kubeflow oraz jako osobna usługa.

##### KF Notebooks `stable`
Kubeflow Notebook to platforma umożliwiająca tworzenie serwerów hostujących Jupyter Notebooki. Pozwala ona na konfiguracje poszczególnych serwerów i udostępnianiu ich publicznie.

##### KF Dashboards `stable`
Dashboards jest komponentem umożliwiającym monitorowanie stanu Kubeflow. Umożliwia on tworzenie odpowiednich widoków, możliwych do skonfigurowania według preferencji użytkownika. Pozwala to na stworzenie pojedynczej strony z wszystkich istotnymi informacjami takimi jak logi, informacje o pipelinach, czy metryki informujące o aktualnym wykorzystaniu zasobów obliczeniowych.

##### KF Katib - AutoML `beta`
**TODO: opis**
![AutoML](img/architecture/automl.png)

##### KF Kubeflow Training Operator - Model Training `stable`
Model Training jest platformą do trenowania modeli sztucznej inteligencji w środowisku rozproszonym. Umożliwia ona szkolenie modelu z wykorzystaniem takich frameworków jak PyTorch, czy TensorFlow. Udostępnia przy tym takie funkcjonalności jak określenie strategii nauki modelu w systemie rozproszonym, czy chociażby job scheduling.
![KTO](img/architecture/kto.png)

##### KF KServe `stable`
Jest platformą do wdrażania wytrenowanych modeli sztucznej inteligencji bazujący na istniejących już technologiach takich jak TFServing czy Triton Inference Server. W dodatku pokrywa on takie funkcjonalności jak logowanie, autoskalowanie, zapewnia authZ i authN, udostępnia metryki, pozwala na kontrolowanie ruchu z wykorzystaniem firewalli.

##### AWS S3
**TODO: opis**\
**TODO: pozostałe komponenty AWSowe**
