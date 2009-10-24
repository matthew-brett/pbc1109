import pbc1109.data as pd
import numpy as np
import venn as venn

ds = pd.PBCData('/home/eg01/Data/PBC/pbc2009icdm')

expert_labels = ds.get_data(1,1).labels[:,1]

np.random.seed(0)
#test_labels = np.random.randint(12,size=250000)
test_labels = expert_labels

#cm = venn.ConfusionMatrix(np.array([[0,0],[0,0],[1,1],[1,2]]))

cm=venn.ConfusionMatrix(np.c_[expert_labels,test_labels])

#cm=venn.ConfusionMatrix(np.c_[expert_labels,expert_labels])

cm.overlap = np.zeros(len(test_labels))##yield assert_array_almost_equal, cm.counts[5,8], 97.0

scores = np.zeros((len(cm.row_cats),2))

for expert_bundle in range(len(cm.row_cats))[1:]:
    print 'Scoring expert fibre bundle with label %d' % expert_bundle
    '''
    using the test labels
    each row tells us how the corresponding expert bundle is labelled
    '''
    cm.overlap[expert_bundle]=sum(cm.counts[expert_bundle,:]>0)
    print 'Number of overlapping test bundles is %d' % cm.overlap[expert_bundle]
    hit_scores = []
    for col in range(len(cm.col_cats)):
        if 2*cm.counts[expert_bundle,col] >= cm.col_counts[col]:
            hit_scores.append((2.*cm.counts[expert_bundle,col]-cm.col_counts[col])/cm.row_counts[expert_bundle])
    print 'Score %f' % sum(hit_scores)
    scores[expert_bundle,:]=(sum(hit_scores),cm.overlap[expert_bundle])

print scores
    