
# all_selected_words = ['face', 'off', 'html', '%', 'width', 'font', 'free', 'tr', 'td', 'cancel', 'color']
# all_words_01 = words_in_texts(all_selected_words, train['email']) 

# feature_X = pd.DataFrame(all_words_01, columns=all_selected_words)

# feature_X['body_length'] = lengthColumn

# count_ex = []
# for i in train['email']:
#     words = i.split(" ")
#     count_ex_word = 0
#     for j in words:
#         if j == "!":
#             count_ex_word += 1
#     count_ex.append(count_ex_word)
    
# s = train['email']
# capital = s.str.extract(r'[A-Z]*(\d)')

# feature_X['count_ex'] = count_ex
# feature_X['capitalized'] = capital

# feature_X = feature_X.fillna(0)

# feature_X['capitalized'][822] = 0
# feature_X['capitalized'][1362] = 0
# feature_X['capitalized'][1573] = 0
# feature_X['capitalized'][2346] = 0
# feature_X['capitalized'][4011] = 0
# feature_X['capitalized'][2559] = 0
# feature_X['capitalized'][5482] = 0
# feature_X['capitalized'][5740] = 0
# feature_X['capitalized'][6329] = 0
# feature_X['capitalized'][6755] = 0
# feature_X['capitalized'][6821] = 0



# pd.to_numeric(feature_X['capitalized']).divide(feature_X['body_length'])



# # cross validation 
# from sklearn.model_selection import KFold

# def rmse(actual_y, predicted_y):
#     return np.sqrt(np.mean((actual_y-predicted_y)**2))

# def compute_CV_arr(X_train, Y_train):
#     kf = KFold(n_splits=4)
#     validation_arrs = []
    
#     for train_idx, valid_idx in kf.split(X_train):
#         # split the data
        
#         split_X_train, split_X_valid = X_train.iloc[train_idx], X_train.iloc[valid_idx]
#         split_Y_train, split_Y_valid = Y_train[train_idx], Y_train[valid_idx]

#         # Fit the model on the training split
# #         print(split_X_train)
# #         print(split_Y_train)
# #         print(split_X_valid)
# #         print(split_Y_valid)
# #         x_train = []
# #         for i in split_X_train:
# #             x_train.append([i])
# #         x_valid = []
# #         for j in split_X_valid:
# #             x_valid.append([j]) 
            
# #         print(x_train)
# #         print(split_Y_train)
# #         print(x_valid)
# #         print(split_Y_valid)
#         model = LogisticRegression(random_state=0, solver='lbfgs', multi_class='multinomial').fit(split_X_train, split_Y_train)
#         #model.fit(split_X_train, split_Y_train)
        
#         # Compute the RMSE on the validation split
# #         Y_predTrain = model.predict(split_X_train)
#         Y_predValid = model.predict(split_X_valid)
# #                 
#         Y_pred_Va_prob = []
#         prob_va = model.predict_proba(split_X_valid)
#         for j in prob_va:
#             if j[0] >= 0.7:
#                 Y_pred_Va_prob.append([1])
#             else:
#                 Y_pred_Va_prob.append([0])
# #         print(Y_pred_Va_prob)
#         #print(split_Y_valid)
# #         train_error = rmse(split_Y_train, Y_predTrain)
#         split_Y_valid = np.transpose(split_Y_valid)
#         #Y_pred_Va_prob = np.transpose(Y_pred_Va_prob)
#         arr = model.score(Y_pred_Va_prob, split_Y_valid)
        
#         validation_arrs.append(arr)
        
#     return np.mean(validation_arrs)


# # feature_sets = [
# #     ['face', 'off', 'html', '%', 'width', 'font', 'free', 'tr', 'td', 'cancel', 'color'], 
# #     ['face', 'off', 'html', '%', 'width', 'font', 'body_length', 'count_ex', 'capitalized'], 
# #     ['free', 'tr', 'td', 'cancel', 'color', 'body_length', 'count_ex', 'capitalized'], 
# #     ['face', 'off', 'html', '%', 'width', 'font', 'free', 'tr', 'td', 'cancel', 'color', 'body_length', 'count_ex', 'capitalized']
# # ]
# feature_sets = [
#     ['face', 'off', 'html', '%', 'width'], 
#     ['face', 'off', 'html', '%', 'width'], 
#     ['free', 'tr', 'td', 'cancel',  '%'], 
#     ['color', 'body_length', 'count_ex', 'capitalized', '%']
# ]

# #first_feature_set = feature_X[['face', 'off', 'html', '%', 'width']]
# # errors = []
# training_accuracy = []
# for feat in feature_sets:
#     print("Trying features:", feat)
#     #model = LogisticRegression(random_state=0, solver='lbfgs', multi_class='multinomial').fit(first_feature_set, Y_train)
# #     error = compute_CV_error(model, feature_X[feat], Y_train)    # compute the cross validation error
#     arr = compute_CV_arr(feature_X[feat], Y_train) 
#     print("\accuracy:", arr)
#     errors.append(error)
#     training_accuracy.append(arr)

# best_err_idx = errors.index(min(errors))
# best_err = min(errors)

# best_feature_set = ['face', 'off', 'html', '%', 'width', 'font', 'body_length', 'count_ex', 'capitalized']


# # YOUR CODE HERE
# # raise NotImplementedError()


# for i in range(4):
#     print('{}, arr: {}'.format(feature_sets[i], training_accuracy[i]))

# best_feature_set, best_err


from sklearn.metrics import accuracy_score
from sklearn.feature_extraction.text import CountVectorizer
vectorizer = CountVectorizer()

!pip install --upgrade nltk
import nltk
nltk.download('punkt')
nltk.download("stopwords")
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from nltk.corpus import stopwords

X = original_training_data["subject"].as_matrix()
X = vectorizer.fit_transform(X)
Y = original_training_data["spam"].as_matrix()
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2,random_state=42)
model = LogisticRegression(C=10,dual=True,fit_intercept=False,max_iter=25,penalty="l2").fit(X_train, Y_train)

accuracy_score(model.predict(X_test),Y_test)

,'God','events','check','cash','pay','how','what','book','text','head','hair','home','friends','party','Google','click','Clickthru','through','hit','anytime','won','only','no','here','wife','gift','give','sorry','apologize','song','right','many','ticket','deal','No','no','yes','Yes','great','got']

Phi_train = np.array(words_in_texts(some_words, train['email']))
,'God','events','check','cash','pay','how','what','book','text','head','hair','home','friends','party','Google','click','Clickthru','through','hit','anytime','won','only','no','here','wife','gift','give','sorry','apologize','song','right','many','ticket','deal','No','no','yes','Yes','great','got']


