#!/usr/bin/env python

import os, sys
import subprocess

def zopen(path, mode='r'):
	gzip_executable = 'gzip'
	#gzip_executable = 'pigz'

	if path[0] == '~':
		path = os.path.expanduser(path)

	if path == '-':
		if mode == 'r':
			return sys.stdin
		elif mode == 'w':
			return sys.stdout

	if path.lower().endswith('.gz'):
		if mode == 'r':
			return subprocess.Popen('gunzip -c %s' % path,
				stdout=subprocess.PIPE, shell=True).stdout
		elif mode == 'w':
			return subprocess.Popen('%s -c > %s' % (gzip_executable, path),
				stdin=subprocess.PIPE, shell=True).stdin
	else:
		return open(path, mode)


def variant_recall(vcf_path, min_alt_reads=2, min_alt_frac=0.05):
  vcf_file = zopen(vcf_path)

  for line in vcf_file:
    line = line.decode("utf-8")
    print(line)
    if not line.startswith('#'): break
  sys.stdout.write(line)

  headers = line.rstrip('\n').split('\t')
  sample_col = headers.index('ESP6500' if 'ESP6500' in headers else 'ALT')+1
  samples = headers[sample_col:]

  for line in vcf_file:
    line = line.decode("utf-8")
    cols = line.rstrip('\n').split('\t')
    gt_reads = [gt.split(':') for gt in cols[sample_col:]]
    alt_reads = [int(gt[0]) for gt in gt_reads]
    total_reads = [int(gt[1]) for gt in gt_reads]

    alt_gt = [alt_reads[s] >= min_alt_reads and
      float(alt_reads[s]) / total_reads[s] >= min_alt_frac
      for s in range(len(alt_reads))]
    if not any(alt_gt): continue

    sys.stdout.write('\t'.join(cols[:sample_col]))
    for s in range(len(total_reads)):
      sys.stdout.write('\t%d:%d%s' % (alt_reads[s], total_reads[s],
        ':*' if alt_gt[s] else ''))
    print()

#vcf_path = sys.argv[1]
#print(vcf_path)
test = variant_recall(sys.argv[1])
