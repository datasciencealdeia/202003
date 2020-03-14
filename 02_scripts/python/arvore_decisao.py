# Árvore de Decisão - Desafio Pessoal - Simpsons
# Curso Noções Data Science - Aldeia
  
import pandas as pd 
import pydotplus
from sklearn.metrics import confusion_matrix 
from sklearn.tree import DecisionTreeClassifier, export_graphviz
from sklearn.metrics import accuracy_score
from sklearn.externals.six import StringIO  

n_classes = 2
caracteristicas=['Laranja','Branco','Azul Escuro','Azul Jeans','Marrom']
rotulos=['bart','homer']
    
treino = pd.read_csv('/home/ds/git/201909/03_dados/desafio pessoal/treino.csv', sep= ';', header = None) 
teste = pd.read_csv('/home/ds/git/201909/03_dados/desafio pessoal/teste.csv', sep= ';', header = None)
    
#Carrega variáveis preditivas e rótulos
X_treino, y_treino = treino.values[:, 0:5], treino.values[:, 6]
X_teste, y_teste = teste.values[:, 0:5], teste.values[:, 6]

#Configura classificador (https://scikit-learn.org/stable/modules/generated/sklearn.tree.DecisionTreeClassifier.html
classificador = DecisionTreeClassifier(random_state = 0) 

# Ajusta e gera o modelo treinado com base nas features/características 
classificador = classificador.fit(X_treino, y_treino) 

# Realiza a predição com novos valores / teste
y_predito = classificador.predict(X_teste) 

# Calcula acurácia entre valor predito e valor real rotulado no teste
accur = accuracy_score(y_teste,y_predito)*100
print ("Acurácia: %.2f%%" %accur)

# Apresenta a matriz confusão - https://en.wikipedia.org/wiki/Confusion_matrix
#         ROTULO
# PRED    Homer    Bart
# Homer   OK       NOK
# Bart    NOK      OK
#
cm = confusion_matrix(y_teste, y_predito, labels=['homer','bart'])
print ("Matriz Confusão: \n")
print (cm)

dot_data = StringIO()
export_graphviz(classificador, out_file=dot_data, filled=True, rounded=True, special_characters=True, feature_names=caracteristicas, class_names=rotulos)
graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  
graph.write_png("/home/ds/git/201909/03_dados/desafio pessoal/dtree.png")


