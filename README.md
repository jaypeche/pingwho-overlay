# pingwho-overlay

## Gentoo Linux overlay


This overlay is intended to host my personal applications,
in order to redistribute them via this Gentoo repository.

### Install repository :


```
emerge -av eselect-repository
```

```
eselect repository add pingwho-overlay git https://github.com/jaypeche/pingwho-overlay.git
```

```
emaint sync -r pingwho-overlay 
```


### Emerging packages :


This unofficial repository requires certain packages to be unmasked.
For example, you'll need to:


```
echo "sci-ml/ollama-bin ~amd64" >> /etc/portage/package.accept_keywords/ollama
```


Then you can emerge the package :


```
emerge -av ollama-bin
```


### Bugs and issues :
* https://github.com/jaypeche/pingwho-overlay/issues
