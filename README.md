Currently only linux x86_64 systems are supported.


## Intasll

`./install.sh`


## Setup Tailscale

1. You will need to install tailscale on the control plane machine (the machien where you intsalled k3s)


3. ACL

```
{
	"tagOwners": {
		"tag:fivestack": [],
	},

	"autoApprovers": {
		"routes": {
			"10.42.0.0/16": ["tag:fivestack"],
		},
	},

	// Define access control lists for users, groups, autogroups, tags,
	// Tailscale IP addresses, and subnet ranges.
	"acls": [
		{
			"action": "accept",
			"src":    ["tag:fivestack", "10.42.0.0/16"],
			"dst":    ["tag:fivestack:*", "10.42.0.0/16:*"],
		},
	],
}
```


4. Create s3 Bucket at your s3 URL provided 
	A. https://console.5stack.gg/buckets
	B. To to the access keys tab and create a new access key for the user you created in step 1
	C. Copy the access key id and secret to the s3-secrets.env file
	D. re-run `./kustomize build base | kubectl apply -f -` to apply the changes

5. run the `./update` script after updating the s3-secrets.env file


### Update Script Params
--kubeconfig : the path to the kubeconfig file

example:

`./update --kubeconfig ~/.kube/5stack`	