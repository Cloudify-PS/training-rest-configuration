# training-rest-configuration
Training lab to demonstrate the use of configuration plugin

# About the LAB
this lab will give an example on how to use configuration update , the blueprint will create a server on and it will install flask application "Cards" .

```
cfy install env_setup.yaml -b env_setup
```

and in order to test the configuration part another blueprint will be used and given what is specified inside the blueprint on start it will create 3 cards on the server, and given the update values from update.yaml files it will change the properties of these cards that was assigned to the server 

you can install it using the following command :

```
cfy install conf_blueprint.yaml -b configuration_test -i env_setup_deployment_name=env_setup
```
