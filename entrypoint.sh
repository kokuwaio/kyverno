#!/usr/bin/env bash
set -eu;

##
## build command
##

COMMAND="kyverno apply"
if [[ "${PLUGIN_WARN_NO_PASS:-true}" == "true" ]]; then
	COMMAND+=" --warn-no-pass"
fi
if [[ "${PLUGIN_TABLE:-true}" == "true" ]]; then
	COMMAND+=" --table"
fi
if [[ "${PLUGIN_DETAILED_RESULTS:-true}" == "true" ]]; then
	COMMAND+=" --detailed-results"
fi
if [[ -n "${PLUGIN_POLICY:-}" ]]; then
	if [[ "$PLUGIN_POLICY" =~ ^https://.* ]]; then
		COMMAND+=" $PLUGIN_POLICY"
	else
		find "$PLUGIN_POLICY" -type f -iname '*.y*ml' -print0 | xargs -0 yq 'select(.apiVersion == "kyverno.io/v1" and (.kind == "ClusterPolicy" or .kind == "Policy") and (.spec.rules[] | has("context") == false))' > "$PWD/policies.yaml" 
		COMMAND+=" $PWD/policies.yaml"
	fi
else
	echo "No cluster policy source defined."
	exit 1
fi
if [[ -f $PLUGIN_MANIFESTS/kustomization.yaml ]]; then
	kustomize build "$PLUGIN_MANIFESTS" > "$PWD/manifests.yaml"
	echo "Created $PWD/manifests.yaml from $PLUGIN_MANIFESTS"
	# grep -c = count occurrences
	# grep -i = case insensitiv
	# grep -E = extended regex
	# check for patterns like <patched>
	if grep -icE "<.*patched.*>" "$PWD/manifests.yaml"; then
		echo "Found string <.*patched.*> in manifests after kustomize apply:"
		grep -iE "<.*patched.*>" -A10 -B10 "$PWD/manifests.yaml"
		exit 1
	fi
	COMMAND+=" --resource=$PWD/manifests.yaml"
else
	COMMAND+=" --resource=$PLUGIN_MANIFESTS/"
fi

##
## execute command
##

echo "$COMMAND"
eval "$COMMAND"
