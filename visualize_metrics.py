import matplotlib.pyplot as plt
import numpy as np

# Updated Data
datasets = ["Bird", "Spider", "Ambrosia"]
methods = ["Baseline 1", "Baseline 2", "Our Method"]
metrics = [
    "Query Execution Accuracy", "Table Retrieval Precision", "Table Retrieval Recall",
    "Table Retrieval F1", "Column Retrieval Precision", "Column Retrieval Recall",
    "Column Retrieval F1", "BLEU score"
]

# Updated values for each metric (rows are metrics, columns are methods within each dataset)
values = {
    "Query Execution Accuracy": [
        [0.1888, 0.602, 0.565], [0.829, 0.805, 0.865], [0, 0, 0]
    ],
    "Table Retrieval Precision": [
        [0.5937, 0.7871, 0.7573], [0.9421, 0.9633, 0.9622], [0.7133, 0.6281, 0.5336]
    ],
    "Table Retrieval Recall": [
        [0.598, 0.7764, 0.7435], [0.9456, 0.9427, 0.9779], [0.712, 0.6231, 0.5036]
    ],
    "Table Retrieval F1": [
        [0.5886, 0.7715, 0.7389], [0.9378, 0.9456, 0.9644], [0.7117, 0.6189, 0.5105]
    ],
    "Column Retrieval Precision": [
        [0.2053, 0.3517, 0.1671], [0.293, 0.3891, 0.5314], [0.4283, 0.2153, 0.1955]
    ],
    "Column Retrieval Recall": [
        [0.209, 0.3393, 0.1642], [0.2959, 0.3748, 0.529], [0.4022, 0.1956, 0.1763]
    ],
    "Column Retrieval F1": [
        [0.2043, 0.342, 0.1628], [0.2892, 0.3766, 0.5212], [0.4115, 0.2009, 0.1798]
    ],
    "BLEU score": [
        [0.2044, 0.3059, 0.1575], [0.2063, 0.2631, 0.3305], [0.2676, 0.0998, 0.0676]
    ]
}

# Plotting
bar_width = 0.2  # Bar width for spacing
colors = ['#1f77b4', '#ff7f0e', '#2ca02c']  # Colors for methods (consistent)

# Generate one graph for each dataset
for i, dataset in enumerate(datasets):
    plt.figure(figsize=(10, 6))
    x = np.arange(len(metrics))  # Metric indices
    
    for j, method in enumerate(methods):
        dataset_values = [values[metric][i][j] for metric in metrics]
        bar_positions = x + j * bar_width
        plt.bar(
            bar_positions,
            dataset_values,
            bar_width,
            color=colors[j],
            label=method
        )
    
    # Add labels, title, and legend
    plt.xlabel("Metrics")
    plt.ylabel("Values")
    plt.title(f"Comparison of Methods Across Metrics for {dataset}")
    plt.xticks(x + bar_width, metrics, rotation=45, ha="right")
    plt.legend(title="Methods")
    
    # Adjust layout and display
    plt.tight_layout()
    plt.show()
