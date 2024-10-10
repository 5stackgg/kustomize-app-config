Currently only linux x86_64 systems are supported.

Running `./install.sh` should walk you through the process of setting up the 5stack panel.

## Using Reverse Proxy

### Tailscale ACL

You should limit the access that tilasclae will give to these machines. The following is an example of what the ACL should look like.

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

### Minio Setup

Create Minio Bucket at your Minio URL provided in your config
A. https://console.5stack.gg/buckets
B. To to the access keys tab and create a new access key for the user you created in step 1
C. Copy the access key id and secret to the s3-secrets.env file
D. re-run `./kustomize build base | kubectl apply -f -` to apply the changes

run the `./update` script after updating the s3-secrets.env file

### Update Script Params

--kubeconfig : the path to the kubeconfig file

example:

`./update --kubeconfig ~/.kube/5stack`
