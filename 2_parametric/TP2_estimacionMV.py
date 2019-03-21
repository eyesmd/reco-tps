import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

mu = 0
sigma = 1

fig, axes = plt.subplots(2, 2, sharex=True)
axes = axes.flatten()
sizes = [10, 100, 1000, 2000]

for i in range(0, 4):
    print('Muestreando (Tamaño ' + str(sizes[i]) + ')...', end='', flush=True)
    n = sizes[i]
    estimations = []
    for j in range(0, 10_000):
        samples = np.random.normal(size=n) * sigma + mu
        estimations.append(samples.mean())
    ax = axes[i]
    ax.hist(estimations, 50, normed=1) # normed normalizes area
    ax.set_title(n)
    print(' Ok')

print('Graficando... Ok')
plt.show()
