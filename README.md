# ☁️ Provisioning d’infrastructure Azure avec Terraform – Projet DataCorp

## 🎯 Objectif du projet

Ce projet a pour objectif de découvrir et maîtriser les bases de **Terraform** en automatisant le déploiement d’une infrastructure cloud simple sur **Microsoft Azure**, dans un contexte de **Data Engineering**.

L’infrastructure déployée simule un environnement minimal permettant :

* 🗄️ le **stockage de données** via un Storage Account et un Blob Container,
* 🌐 l’**exposition de services ou de résultats** via une Web App Azure,
* 🖥️ l’**exécution de traitements ou de tests** sur une machine virtuelle Linux.

Toutes les ressources sont déployées via Terraform en respectant les principes de l’**Infrastructure as Code (IaC)**.

---

## 🧱 Architecture déployée

### Ressources Azure

* **Resource Group** : existant (fourni par l’organisation / la formation)
* **Storage Account**

  * Blob Container privé nommé `raw`
* **Web App Azure**

  * App Service Plan (SKU gratuit)
* **Machine Virtuelle Linux**

  * Ubuntu 22.04 LTS
  * Réseau dédié (VNet + Subnet)
  * Public IP (SKU Standard)
  * Network Security Group autorisant le SSH (port 22)

---

## 🛠️ Étapes de création des ressources

Le déploiement de l’infrastructure est réalisé progressivement par Terraform selon les étapes suivantes :

### 1. Initialisation du projet Terraform

Terraform est initialisé afin de :

* télécharger les providers nécessaires (AzureRM, etc.),
* initialiser les modules Terraform,
* préparer le backend local pour le state.

Commande utilisée :

```
terraform init
```

### 2. Récupération du Resource Group existant

Le Resource Group Azure n’est pas créé par Terraform.
Il est récupéré via une **data source** afin d’y déployer les ressources.

Terraform lit :

* le nom du Resource Group,
* sa localisation.

### 3. Création du Storage Account et du Blob Container

Terraform crée ensuite :

* un **Storage Account Azure**,
* un **Blob Container privé** destiné au stockage de données (par exemple des données brutes).

Ces ressources sont gérées dans un module dédié afin de garantir leur indépendance et leur réutilisabilité.

### 4. Déploiement de la Web App

Terraform déploie :

* un **App Service Plan** (SKU gratuit),
* une **Web App Linux** associée à ce plan.

La Web App est déployée sans application afin de servir de base pour de futurs services ou dashboards.

### 5. Création de la Machine Virtuelle Linux

Terraform crée une machine virtuelle Linux comprenant :

* un réseau virtuel (VNet),
* un subnet,
* une adresse IP publique,
* une carte réseau,
* un Network Security Group autorisant l’accès SSH,
* une VM Ubuntu 22.04 LTS.

L’accès SSH est configuré à l’aide d’une clé publique locale.

### 6. Vérification et destruction

Une fois le déploiement terminé :

* les ressources sont vérifiées via le portail Azure ou la CLI,
* la VM est testée via une connexion SSH,
* l’ensemble de l’infrastructure peut être supprimé avec la commande `terraform destroy`.

Cette étape permet de valider le cycle de vie complet de l’infrastructure.

---

## 📁 Structure du projet

```
.
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars        # NON versionné
├── modules/
│   ├── storage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── webapp/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vm/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

---

## ⚙️ Prérequis

### Outils requis

* **Terraform** (version ≥ 1.5)
* **Azure CLI**

### Accès Azure requis

* Un **Resource Group existant**
* Un rôle **Contributor** sur ce Resource Group

---

## 🔐 Authentification Azure

Connexion au compte Azure :

```
az login
```

Sélection de la subscription (si nécessaire) :

```
az account set --subscription "<SUBSCRIPTION_ID>"
```

Export de la subscription pour Terraform :

```
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
```

ℹ️ Cette variable est stockée uniquement dans la session du terminal et n’est **jamais versionnée**.

---

## 📝 Configuration via terraform.tfvars

Certaines valeurs sont spécifiques à l’utilisateur et ne doivent pas être versionnées.

Créer un fichier `terraform.tfvars` (ignoré par Git) :

```
resource_group_name  = "<NOM_DU_RESOURCE_GROUP_EXISTANT>"
ssh_public_key_path  = "/chemin/absolu/vers/.ssh/id_rsa.pub"
```

* Le **Resource Group** n’est pas créé par Terraform.
* Il est récupéré via une **data source** (`data.azurerm_resource_group`).
* Le chemin vers la clé SSH doit être **absolu**.

---

## 🔑 Clé SSH pour la VM

Si aucune clé SSH n’existe sur la machine locale :

```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

Terraform utilisera ensuite la clé publique pour autoriser la connexion SSH à la VM.

---

## 🚀 Déploiement de l’infrastructure

Initialisation du projet Terraform :

```
terraform init
```

Vérification du code :

```
terraform fmt -recursive
terraform validate
terraform plan
```

Déploiement :

```
terraform apply
```

---

## 🔎 Vérification des ressources

### Via le portail Azure

* Storage Account → Container `raw`
* App Services → Web App active
* Virtual Machines → VM Linux en cours d’exécution

### Connexion SSH à la VM

```
ssh azureuser@<VM_PUBLIC_IP>
```

---

## 🔄 Destruction de l’infrastructure

L’ensemble des ressources créées par Terraform peut être supprimé avec :

```
terraform destroy
```

✔️ Toutes les ressources sont supprimées
✔️ Le Resource Group existant reste intact

---

## 🧠 Concepts Terraform mis en œuvre

* Providers (`azurerm`, `random`, `local`)
* Resources et Data Sources
* Modules Terraform
* Variables et propagation des valeurs
* Outputs
* Dépendances implicites
* Cycle de vie : `plan`, `apply`, `destroy`
* Gestion des contraintes Azure (quotas, SKU, régions)

---

## 📌 Notes importantes

* Le dossier `.terraform/` n’est **jamais versionné**
* Le fichier `terraform.tfstate` n’est **jamais versionné**
* Le fichier `.terraform.lock.hcl` est conservé pour garantir la reproductibilité
* Les quotas Azure peuvent varier selon les subscriptions

---

## 👤 Auteur
LucasHzl