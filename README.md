# 🛠️ DAGINFO Toolkit

> **Boîte à outils PowerShell tout-en-un pour la maintenance, le diagnostic et le dépannage de postes Windows.**

---

## 📌 Présentation

**DAGINFO Toolkit** est un script PowerShell interactif doté d'un menu en console. Il permet d'exécuter rapidement et simplement les opérations de maintenance et de diagnostic les plus courantes sur un poste Windows (nettoyage, réseau, imprimantes, matériel, etc.).

Le script intègre un mécanisme d'**auto-élévation de privilèges** : s'il n'est pas lancé en tant qu'administrateur, il demandera automatiquement l'élévation des droits pour s'exécuter correctement.

---

## ✨ Fonctionnalités

Le toolkit est divisé en plusieurs modules accessibles depuis le menu principal :

### 🧼 Maintenance Globale
* **Antivirus :** Analyse rapide avec Windows Defender.
* **Santé Disque :** Vérification rapide de l'état de santé (S.M.A.R.T.).
* **Réparation Système :** Commandes de réparation de l'image (`DISM`) et des fichiers système (`SFC`).
* **Vérification Disque :** Analyse des erreurs de système de fichiers (`CHKDSK`).
* **Explorateur Windows :** Redémarrage rapide du processus `explorer.exe` (utile en cas de gel).
* **Mise à jour Applicative :** Mise à jour globale des logiciels installés via *Winget*.
* **Nettoyage :** Suppression automatique des caches et fichiers temporaires accumulés.

### 🖨️ Dépannage Imprimantes
* Redémarrage rapide du service de spouleur d'impression (*Spooler*).
* Purge automatique des files d'attente d'impression bloquées.
* Raccourci vers les paramètres système des imprimantes.
* Rapport d'état des imprimantes connectées.

### 🔌 Diagnostic et Réparation Réseau
* Affichage clair de la configuration IP active.
* Vidage complet du cache de résolution DNS (*DNS Flush*).
* Libération et renouvellement d'adresse IP (DHCP *Release/Renew*).
* Réinitialisation de la pile TCP/IP et de la couche Winsock.
* Test de connectivité (Ping vers une cible par défaut ou personnalisée).
* Accès direct au panneau des connexions réseau.

### 💻 Analyse Hardware et BIOS
* Redémarrage direct sur l'interface microprogramme UEFI/BIOS.
* Accès aux options de démarrage avancées de Windows.
* Affichage des informations système détaillées (CPU, RAM, Modèle, etc.).
* Statut et gestion du module de plateforme sécurisée (TPM).
* Vérification du statut de la fonctionnalité Secure Boot.
* Récupération de la version exacte
