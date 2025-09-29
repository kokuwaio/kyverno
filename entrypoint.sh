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
		POLICIES=$(find "$PLUGIN_POLICY" -type f -iname '*.yaml' -print0 | xargs -0 -n 1 echo -n " ")
		if [[ ! -n "${POLICIES// /}" ]]; then
			echo "No policies found at $PLUGIN_POLICY."
			exit 1
		fi
		COMMAND+=" $POLICIES"
	fi
else
	echo "No cluster policy source defined."
	exit 1
fi
if [[ -f $PLUGIN_MANIFESTS/kustomization.yaml ]]; then
	kustomize build "$PLUGIN_MANIFESTS" > "$PLUGIN_MANIFESTS/kyverno.yaml"
	echo "Created $PLUGIN_MANIFESTS/kyverno.yaml"
	# grep -c = count occurrences
	# grep -i = case insensitiv
	# grep -E = extended regex
	# check for patterns like <patched>
	if grep -icE "<.*patched.*>" "$PLUGIN_MANIFESTS/kyverno.yaml"; then
		echo "Found string <.*patched.*> in manifests after kustomize apply:"
		grep -iE "<.*patched.*>" -A10 -B10 "$PLUGIN_MANIFESTS/kyverno.yaml"
		exit 1
	fi
	COMMAND+=" --resource=$PLUGIN_MANIFESTS/kyverno.yaml"
else
	COMMAND+=" --resource=$PLUGIN_MANIFESTS/"
fi

##
## execute command
##

echo "$COMMAND"
eval "$COMMAND"
