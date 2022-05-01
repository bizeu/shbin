# coding=utf-8
"""
Shbin Package
"""
import importlib.metadata
import pathlib
app = lambda: print(importlib.metadata.version(pathlib.Path(__file__).parent.name))
