def compress_check(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    genome = ""
    for i in lines:
        if not i.startswith(">"):
            genome += i.strip()

    total_my = 0
    total_naive = 0
    for i in genome:
        total_naive += 2
        if i == 'A':
            total_my += 1
        elif i == 'T':
            total_my += 2
        else:
            total_my += 3

    print(f"\n{filename}")
    print(f"length = {len(genome)}")
    print(f"count A = {genome.count('A')}, count T = {genome.count('T')}, \
count G = {genome.count('G')}, count C = {genome.count('C')}")
    print(f"my: {total_my} bit, naive: {total_naive} bit")
    if total_my < total_naive:
        print("compressed")
    else:
        print("uncompressed")

compress_check("dna/phix174.fasta")
compress_check("dna/plasmodium_mito.fasta")
