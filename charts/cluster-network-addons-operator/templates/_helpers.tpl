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

{{- define "cluster-network-addons-operator.addonImages" -}}
{{- $defaults := dict
  "multus"                          "ghcr.io/k8snetworkplumbingwg/multus-cni@sha256:2b9671447f3ea4e7e56730843dbf59445b9307246f393b61386b896d56ae51c9"
  "multusDynamicNetworksController" "ghcr.io/k8snetworkplumbingwg/multus-dynamic-networks-controller@sha256:c7d137a7f4ddd81233b9778d02ae57a496e892ddedf74d49382d86df50ddcc27"
  "linuxBridge"                     "quay.io/kubevirt/cni-default-plugins@sha256:976a24392c2a096c38c2663d234b2d3131f5c24558889196d30b9ac1b6716788"
  "linuxBridgeMarker"               "quay.io/kubevirt/bridge-marker@sha256:f9611ec10bb4aec44b0ec19f9b9d748a36255c089a1f59bc76e5fc37acc0fed2"
  "ovsCNI"                          "ghcr.io/k8snetworkplumbingwg/ovs-cni-plugin@sha256:435f374b434b3bc70a5cfaba0011fdcf5f433d96b98b06d29306cbd8db3a8c21"
  "kubeMacPool"                     "quay.io/kubevirt/kubemacpool@sha256:22b6f29367fc5f4ff2a1fbc18f3a5db1e9b090208bf21c6962c36b6053100f79"
  "macVTapCNI"                      "quay.io/kubevirt/macvtap-cni@sha256:aee6d9beb458fa76b0eab34335e2b528ad9eaff74b87be2fd62658ba77cbfa87"
  "kubeVirtIPAMController"          "ghcr.io/kubevirt/ipam-controller@sha256:83f03d3185ee5b27489ae4cb876bf64c9a0b9a910724deae8c341bfae0531152"
-}}
{{- merge (deepCopy (.Values.imageOverrides | default dict)) $defaults | toYaml -}}
{{- end -}}
*/}}

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
