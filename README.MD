# Hiera Single Yaml

The goal of this hiera backend is to have only one file for hiera data values.

Each variable is a Hash with hierarchic path as key and variable value as value.

# Example

```single.yaml
---
value:
 /common: default 			#for all expect redhat family
 /osfamily/redhat: osfamily #value for redhat family (centos, redhat, suse...)
 
nullvalue:
 /common: default
 /osfamily/redhat: null		#reset value for redhat family
 
arrayvalue:
 /common:
    - a
    - b
 /osfamily/redhat: string
```

# Hiera.yaml configuration

You can use :

* :datafile : to specify the location of the data file

```hiera.yaml
---
 :backends:
   - singleyaml
 :hierarchy:
   - osfamily/%{::osfamily}
   - common
 :singleyaml
   :datafile: ./hieradata/single.yaml
```