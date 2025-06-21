# pingwho-overlay

## Gentoo Linux overlay


This overlay is intended to host my personal applications,
in order to redistribute them via this Gentoo repository.

### Install repository :


```
root@localhost # emerge -av eselect-repository
```

```
root@localhost # eselect repository add pingwho-overlay git git://github.com/jaypeche/pingwho-overlay.git
```

```
root@localhost # emaint sync -r pingwho-overlay 
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