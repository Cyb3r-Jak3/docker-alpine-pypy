import os
import requests

def save_file(url: str) -> None:
    """Saves a file from R2"""
    resp = requests.get(url, timeout=300)
    if resp.status_code == 200:
        with open(url.split("/")[-1], "wb") as file:
                file.write(resp.content)
    else:
        raise Exception(f"Failed to download {url} with status code {resp.status_code}")

def main():
    PYPY_BASE = os.environ["PYPY_BASE"]
    PYPY_VERSION = os.environ["PYPY_VERSION"]
    PYPY_BASES= PYPY_BASE.split(",")
    ARCHES = ["x86_64", "aarch64"]
    base_url= "https://pypy.cyberjake.xyz/pypy/{base}/pypy{base}-v{pypy_version}-linux-{arch}-alpine.tar.bz2"
    for base in PYPY_BASES:
        for arch in ARCHES:
            file_url = base_url.format(
                base=base,
                pypy_version=PYPY_VERSION,
                arch=arch
            )
            save_file(file_url)
            save_file(f"{file_url}.sig")

if __name__ == "__main__":
    main()