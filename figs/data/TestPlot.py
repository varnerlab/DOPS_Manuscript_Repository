#!/usr/bin/env python
# a bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt

N = 3
ind = np.arange(N)      # the x locations for the groups
width = 0.35            # the width of the bars
fig, ax = plt.subplots()

dds_means = (0.92,0.06,0.01)
dds_std = (0.06,0.02,0.001)
rects1 = ax.bar(ind, dds_means, width, color='k', yerr=dds_std)

de_means = (0.85,0.17,0.01)
de_std = (0.03,0.03,0.006)
rects2 = ax.bar(ind + width+0.1, de_means, width, color='y', yerr=de_std)

pso_means = (0.86,0.58,0.58)
pso_std = (0.02,0.07,0.07)
rects3 = ax.bar(ind + 2*width+0.1, pso_means, width, color='r', yerr=pso_std)

sa_means = (0.94,0.68,0.65)
sa_std = (0.05,0.09,0.08)
rects4 = ax.bar(ind + 3*width+0.1, sa_means, width, color='b', yerr=sa_std)

# add some text for labels, title and axes ticks
# ax.set_ylabel('Mean scaled error (N = 25)')
# ax.set_xticklabels(('Initial', 'Midpoint', 'End'))
#
# ax.legend((rects1[0], rects2[0]), ('Men', 'Women'))


def autolabel(rects):
    # attach some text labels
    for rect in rects:
        height = rect.get_height()
        ax.text(rect.get_x() + rect.get_width()/2., 1.05*height,
                '%d' % int(height),
                ha='center', va='bottom')

autolabel(rects1)
autolabel(rects2)

plt.show()
