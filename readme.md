# FluxCD Check Action

Diese Action prüft eine oder mehrere angegebene Pfade ob kustomizations mit kustomize build korrekt gebaut werden können und ob die generierten Yamls syntaktisch korrekt sind. Hier zu wird der Output von kustomize build von kubeconform geprüft.

## Verwendung

```
jobs:
  flux-kustomize-lint:
    name: FluxCD Kustomize Lint
    runs-on: ubuntu-latest
    steps:

      - uses: actions/checkout@v2

      - name: Check Flux Cluster Folder
        uses: sueddeutsche/szdm-fluxcd-kustomize-check@v1
        with:
          check-paths: flux/clusters
```

Diese Action hat mehrere Eingabe Parameter:

```
  check-paths:
    description: 'One or space separated path definitions'
    required: true
  kustomize-version:
    description: 'Version of kustomize to install'
    required: false
    default: 'latest'
  kubeconform-version:
    description: 'Version of kubeconform to install'
    required: false
    default: 'latest'
  yq-version:
    description: 'Version of yq to install'
    required: false
    default: 'latest'
  no-check:
    description: 'Only install tools, no check'
    required: false
    default: false
```

* `check-paths` kann einen oder mehrere Pfade beinhalten. Mehrere Pfade werden mit einem Leerzeichen getrennt. 
* `*-version` definiert die Version. Wird keine angegeben wird automatisch die aktuellste Version gezogen.
* `no-check` definiert, dass keine Prüfung verwendet wird, jedoch die Tools installiert werden. Damit kann man z.b. `kustomize` dann in diesem Job weiter verwenden.
