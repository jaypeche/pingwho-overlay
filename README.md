# pingwho-overlay

## Gentoo Linux overlay

This overlay is intended to host my personal applications,
in order to redistribute them via this Gentoo repository.

## Install repository :

```
root@localhost # emerge -av eselect-repository

root@localhost # eselect repository add pingwho-overlay git git://github.com/jaypeche/pingwho-overlay.git

root@localhost # emaint sync -r pingwho-overlay 
```
