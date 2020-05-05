class QuestionnaireController < ApplicationController
  require 'Rx'
  require 'yaml'

  respond_to? :html, :js

  def index
    redirect_to new_questionnaire_path
  end

  def show
    @questionnaire = Questionnairy.where(title: params[:id])

    if @questionnaire.present?
      yaml_file = File.read @questionnaire.last.yaml_path
      @yaml = YAML.load(yaml_file)
    end
  end

  def new
    @questionnaire = Questionnairy.new
  end

  def create
    @questionnaire = Questionnairy.new(questionnaire_params)

    yaml_file = File.read params[:questionnairy][:yaml_file].path
    validatable = YAML.load(yaml_file)
    slide_validation = SlideValidation.new
    valid_data = slide_validation.call(validatable)

    flash[:error] = []
    if valid_data.errors.to_h.present?
      valid_data.errors.to_h.each do |key, val|
        flash[:error] << "#{key} + #{val}"
      end
    end

    @questionnaire.title = validatable["reference"]

    if @questionnaire.valid? && flash[:error].blank?
      @questionnaire.save
      flash[:notice] = "L'upload du questionnaire a réussi"
    else
      redirect_to new_questionnaire_path
    end

  end

  private

  def questionnaire_params
    params.require(:questionnairy).permit!
  end
end
