# ChatGPT-Scripts
utils and scripts made with by GPT, may be modified if needed

kubectl get pods -o json | jq '.items[].spec.containers[].image' | awk -F':' '{print $2}' | sort | uniq
