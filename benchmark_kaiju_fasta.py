import sys

MAP = "/storage/lunajang/metabuli/gtdb-taxdump/R220/seqid2taxid.map"
IN  = "/storage/lunajang/metabuli/benchmark/database-genome.fna"
OUT = "/storage/lunajang/metabuli/benchmark/database-genome.taxid.fna"

m = {}
with open(MAP, 'r', encoding='utf-8', errors='ignore') as f:
    for line in f:
        if not line.strip(): continue
        # 탭/스페이스 모두 허용
        parts = line.strip().split()
        if len(parts) >= 2:
            m[parts[0]] = parts[1]

with open(IN, 'r', encoding='utf-8', errors='ignore') as fin, \
     open(OUT, 'w', encoding='utf-8') as fout:
    for line in fin:
        if line.startswith('>'):
            # 첫 공백 이전까지가 id
            first = line[1:].split(None, 1)[0]  # "NZ_...."
            taxid = m.get(first)
            if taxid:
                fout.write(f">{taxid}\n")
            else:
                # 매핑 없으면 원본 유지(필요시 여기서 교체 정책 바꿔도 됨)
                fout.write(line)
        else:
            fout.write(line)