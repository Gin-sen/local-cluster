{{/*
PROM
Expand the name of the chart.
*/}}
{{- define "prom-stack-service.name-prometheus" -}}
{{- printf "%s-prometheus" (default .Chart.Name .Values.nameOverride) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
GRAFANA
Expand the name of the chart.
*/}}
{{- define "prom-stack-service.name-grafana" -}}
{{- printf "%s-grafana" (default .Chart.Name .Values.nameOverride) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
PROM
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prom-stack-service.fullname-prometheus" -}}
{{- if .Values.fullnameOverride }}
{{- printf "%s-prometheus" .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-prometheus" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-prometheus" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
GRAFANA
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prom-stack-service.fullname-grafana" -}}
{{- if .Values.fullnameOverride }}
{{- printf "%s-grafana" .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-grafana" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-grafana" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "prom-stack-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
PROM
Common labels
*/}}
{{- define "prom-stack-service.labels-prometheus" -}}
helm.sh/chart: {{ include "prom-stack-service.chart" . }}
{{ include "prom-stack-service.selectorLabels-prometheus" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "prom-stack-service.selectorLabels-prometheus" -}}
app.kubernetes.io/name: {{ include "prom-stack-service.name-prometheus" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
GRAFANA
Common labels
*/}}
{{- define "prom-stack-service.labels-grafana" -}}
helm.sh/chart: {{ include "prom-stack-service.chart" . }}
{{ include "prom-stack-service.selectorLabels-grafana" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "prom-stack-service.selectorLabels-grafana" -}}
app.kubernetes.io/name: {{ include "prom-stack-service.name-grafana" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
