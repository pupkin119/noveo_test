require "rails_helper"

RSpec.describe QuestionnaireController do
  # before :each do
  #   @file = fixture_file_upload('files/questionnaire_ok.yml', 'text/yaml')
  # end

  describe "GET #index" do
    subject {get :index}

    it "redirect to action :new template" do
      expect(subject).to redirect_to("/questionnaire/new")
      expect(subject).to redirect_to(:new_questionnaire)
    end

    it "does not redirect to a different :action" do
      expect(subject).to_not render_template("gadgets/show")
    end
  end

  describe "POST #create" do
    it "can upload a file" do
      post :create, params: {
          questionnairy: {
              yaml_file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/questionnaire_ok.yml"),
          }
      }
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "its render teamplate show" do
      get :show, params: { id: "questionnaire_example" }
      expect(response).to render_template(:show)
    end
  end
end