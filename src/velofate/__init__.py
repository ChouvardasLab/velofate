"""velofate: a meta-package for the scRNA-seq -> RNA velocity -> cell-fate workflow.

Installing velofate pulls in the version-pinned tool stack. Import the tools
directly as usual (``import scanpy as sc``, ``import scvelo as scv``, ...);
use ``velofate.versions()`` to check that the active environment matches.
"""

from importlib.metadata import PackageNotFoundError, version

__version__ = "0.1.0"

CORE_PACKAGES = (
    "anndata",
    "scanpy",
    "bbknn",
    "scvelo",
    "cellrank",
    "pygpcca",
    "celltypist",
    "infercnvpy",
    "numpy",
    "scipy",
    "pandas",
)


def versions(packages=CORE_PACKAGES) -> dict:
    """Return (and print) the installed versions of the core workflow packages."""
    found = {}
    for pkg in packages:
        try:
            found[pkg] = version(pkg)
        except PackageNotFoundError:
            found[pkg] = "not installed"
    width = max(len(p) for p in found)
    for pkg, ver in found.items():
        print(f"{pkg:<{width}}  {ver}")
    return found


__all__ = ["__version__", "versions", "CORE_PACKAGES"]
