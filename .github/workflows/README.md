# GitHub Actions Workflow

## 🚀 Déploiement Automatique sur GitHub Pages

Ce workflow déploie automatiquement l'application Flutter sur GitHub Pages à chaque push sur la branche `main`.

### Configuration Requise

1. **Activer GitHub Pages dans votre repo**
   - Allez dans : `Settings` > `Pages`
   - Source : `GitHub Actions`

2. **Modifier le base-href si nécessaire**
   - Dans `.github/workflows/deploy.yml`, ligne 33
   - Remplacez `/Recherche/` par le nom de votre repository
   - Format : `--base-href "/NOM_DU_REPO/"`

### Déclenchement

Le workflow se déclenche automatiquement :
- ✅ À chaque `git push` sur la branche `main`
- ✅ Manuellement via l'onglet "Actions" sur GitHub

### Étapes du Workflow

1. **Checkout** : Clone le repository
2. **Setup Flutter** : Installe Flutter 3.24.0
3. **Install dependencies** : `flutter pub get`
4. **Build web** : Compile l'app en version web
5. **Upload artifact** : Prépare les fichiers
6. **Deploy** : Déploie sur GitHub Pages

### URL de l'Application

Après déploiement, votre app sera accessible à :
```
https://VOTRE_USERNAME.github.io/Recherche/
```

### Commandes Git

```bash
# Pousser vers GitHub (déclenche le déploiement)
git add .
git commit -m "Update app"
git push origin main

# Vérifier le statut du déploiement
# Allez sur GitHub > Actions
```

### Durée du Build

⏱️ Environ 3-5 minutes par déploiement

### Troubleshooting

**Erreur : Page not found**
- Vérifiez que GitHub Pages est activé
- Vérifiez le `base-href` dans le workflow

**Erreur : Build failed**
- Vérifiez les logs dans l'onglet "Actions"
- Assurez-vous que `flutter pub get` fonctionne localement

**Erreur : Permission denied**
- Vérifiez les permissions dans `Settings` > `Actions` > `General`
- Activez "Read and write permissions"
