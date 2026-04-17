{{/*
Expand the name of the chart.
*/}}
{{- define "cluster-network-addons-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cluster-network-addons-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cluster-network-addons-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cluster-network-addons-operator.labels" -}}
helm.sh/chart: {{ include "cluster-network-addons-operator.chart" . }}
{{ include "cluster-network-addons-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cluster-network-addons-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cluster-network-addons-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cluster-network-addons-operator.serviceAccountName" -}}
{{- default (include "cluster-network-addons-operator.fullname" .) .Values.serviceAccountName }}
{{- end }}

{{/*
Addon image defaults merged with any overrides from .Values.imageOverrides
*/}}
{{- define "cluster-network-addons-operator.addonImages" -}}
{{- $defaults := dict
  "multus"                          "ghcr.io/k8snetworkplumbingwg/multus-cni@sha256:3c20900b5381fac7f9cbbdfac8370ea10a2f6ed7fbecc678384a9db57047abb1"
  "multusDynamicNetworksController" "ghcr.io/k8snetworkplumbingwg/multus-dynamic-networks-controller@sha256:2a2bb32c0ea8b232b3dbe81c0323a107e8b05f8cad06704fca2efd0d993a87be"
  "linuxBridge"                     "quay.io/kubevirt/cni-default-plugins@sha256:976a24392c2a096c38c2663d234b2d3131f5c24558889196d30b9ac1b6716788"
  "linuxBridgeMarker"               "quay.io/kubevirt/bridge-marker@sha256:f9611ec10bb4aec44b0ec19f9b9d748a36255c089a1f59bc76e5fc37acc0fed2"
  "ovsCNI"                          "ghcr.io/k8snetworkplumbingwg/ovs-cni-plugin@sha256:435f374b434b3bc70a5cfaba0011fdcf5f433d96b98b06d29306cbd8db3a8c21"
  "kubeMacPool"                     "quay.io/kubevirt/kubemacpool@sha256:fee2954568d346c3be9c1ae4353dc6b3acc57a80bf55f008d84ac5ac557b8104"
  "macVTapCNI"                      "quay.io/kubevirt/macvtap-cni@sha256:5266955a654a4cb4e425424ab274cf31e7a6deb3f340e3679a11d689bfa734d0"
  "kubeSecondaryDNS"                "ghcr.io/kubevirt/kubesecondarydns@sha256:f5fe9c98fb6d7e5e57a6df23fe82e43e65db5953d76af44adda9ab40c46ad0bf"
  "coreDNS"                         "registry.k8s.io/coredns/coredns@sha256:a0ead06651cf580044aeb0a0feba63591858fb2e43ade8c9dea45a6a89ae7e5e"
  "kubeVirtIPAMController"          "ghcr.io/kubevirt/ipam-controller@sha256:08f250f46f932beb81f82a8fdd003824815a726034d2aa2d58d59feb34496db3"
-}}
{{- merge (deepCopy (.Values.imageOverrides | default dict)) $defaults | toYaml -}}
{{- end -}}

{{/*
Create unified annotations for crds
*/}}
{{- define "cluster-network-addons-operator.crds.annotations" -}}
{{- $Release :=(.helm).Release | default .Release -}}
{{- if .Values.crds.keep }}
helm.sh/resource-policy: keep
{{- end }}
meta.helm.sh/release-namespace: {{ $Release.Namespace }}
meta.helm.sh/release-name: {{ $Release.Name }}
{{- end -}}
