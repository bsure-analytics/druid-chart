{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "druid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "druid.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := .Values.nameOverride | default .Chart.Name }}
{{- if .Release.Name | contains $name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "druid.labels" -}}
helm.sh/chart: {{ include "druid.chart" . }}
{{ include "druid.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ quote .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "druid.name" -}}
{{- .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Transform a dictionary to Java system properties.
*/}}
{{- define "druid.properties" -}}
{{- include "druid._properties" (dict "dict" . "prefix" "") }}
{{- end }}

{{/*
Transform a dictionary to Java system properties.
This template expects a dictionary of the form `dict "dict" myDict "prefix" myPrefix` as its context.
*/}}
{{- define "druid._properties" -}}
{{- $prefix := .prefix }}
{{- range $key, $_ := .dict }}
{{- $fullKey := print $prefix $key }}
{{- if kindIs "map" . }}
{{- include "druid._properties" (dict "dict" . "prefix" (print $fullKey ".")) }}
{{- else if kindIs "string" . }}
{{ $fullKey }}={{ . }}
{{- else }}
{{ $fullKey }}={{ toRawJson . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
y{{- define "druid.selectorLabels" -}}
app.kubernetes.io/name: {{ include "druid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "druid.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default (include "druid.fullname" .) }}
{{- else }}
{{- .Values.serviceAccount.name | default "default" }}
{{- end }}
{{- end }}
