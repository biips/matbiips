function model2 = clone_model(model)
%CLONE_MODEL Creates a clone of the model
%

model2 = biips_model(model.file, model.data, 'sample_data', false, 'quiet', true);