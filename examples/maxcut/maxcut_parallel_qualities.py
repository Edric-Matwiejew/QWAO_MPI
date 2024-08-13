from quop_mpi.algorithm.combinatorial import qaoa
import numpy as np
import networkx as nx

Graph = nx.circular_ladder_graph(4)
nodes = len(Graph.nodes)
system_size = 2 ** nodes
G = nx.to_scipy_sparse_array(Graph)


def parallel_maxcut_qualities(local_i, local_i_offset, G):

    n_qubits = G.shape[0]
    qualities = np.zeros(local_i, dtype=np.float64)
    start = local_i_offset
    finish = local_i_offset + local_i

    for i in range(start, finish):
        bit_string = np.binary_repr(i, width=n_qubits)
        for j, bj in enumerate(bit_string):
            for k, bk in enumerate(bit_string):
                if G[j, k] != 0 and int(bj) != int(bk):
                    qualities[i - local_i_offset] -= 1
    return qualities


alg = qaoa(system_size)
alg.set_qualities(parallel_maxcut_qualities, {'args':[G]})
alg.set_depth(2)
alg.execute()
alg.print_result()
alg.save("maxcut_parallel_qualities", "depth 2", "w")