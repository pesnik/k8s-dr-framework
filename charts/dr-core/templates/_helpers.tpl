{{/*
Expand the name of the chart.
*/}}
{{- define "dr-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "dr-core.fullname" -}}
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
{{- define "dr-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dr-core.labels" -}}
helm.sh/chart: {{ include "dr-core.chart" . }}
{{ include "dr-core.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dr-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dr-core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dr-core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dr-core.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate backup image name
*/}}
{{- define "dr-core.backupImage" -}}
{{- printf "%s:%s" .Values.global.image.repository .Values.global.image.tag }}
{{- end }}

{{/*
Generate storage secret name
*/}}
{{- define "dr-core.storageSecretName" -}}
{{- default "cloud-storage-credentials" .Values.storage.credentialsSecret }}
{{- end }}
