{{/*
Expand the name of the chart.
*/}}
{{- define "kubevirt-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubevirt-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubevirt-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubevirt-operator.labels" -}}
helm.sh/chart: {{ include "kubevirt-operator.chart" . }}
{{ include "kubevirt-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kubevirt-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubevirt-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubevirt-operator.serviceAccountName" -}}
{{- default (include "kubevirt-operator.fullname" .) .Values.serviceAccountName }}
{{- end }}

{{/*
Create unified annotations for crds
*/}}
{{- define "kubevirt-operator.crds.annotations" -}}
{{- $Release :=(.helm).Release | default .Release -}}
{{- if .Values.crds.keep }}
helm.sh/resource-policy: keep
{{- end }}
meta.helm.sh/release-namespace: {{ $Release.Namespace }}
meta.helm.sh/release-name: {{ $Release.Name }}
{{- end -}}