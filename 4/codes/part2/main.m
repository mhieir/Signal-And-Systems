%% 3
train_dataset = readtable('diabetes-training.csv');
actual_train_labels = train_dataset.label;
predicted_train_labels = trainedModel.predictFcn(train_dataset);
train_score = sum(predicted_train_labels == actual_train_labels) / numel(actual_train_labels) * 100;
fprintf('Training Accuracy: %.2f%%\n', train_score);
%% 4
val_dataset = readtable('diabetes-validation.csv');
actual_val_labels = val_dataset.label;
predicted_val_labels = trainedModel.predictFcn(val_dataset);
val_score = sum(predicted_val_labels == actual_val_labels) / numel(actual_val_labels) * 100;
fprintf('Validation Accuracy: %.2f%%\n', val_score);