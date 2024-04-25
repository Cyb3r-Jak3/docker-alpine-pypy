import subprocess
import sys
import hashlib

BUF_SIZE = 1048576   # lets read stuff in 64kb chunks!


def sign(filename: str):
    subprocess.run(["gpg", "--quiet", "--batch", "--yes", "--detach-sign", filename])
    sha256sum = hashlib.sha256()
    with open(sys.argv[1], 'rb') as f:
        while True:
            data = f.read(BUF_SIZE)
            if not data:
                break
            sha256sum.update(data)
    with open(f"{filename}.sha256sum", "w") as f:
        f.write(f"{sha256sum.hexdigest()}  {filename.split('/')[-1]}")


if __name__ == "__main__":
    sign(sys.argv[1])
