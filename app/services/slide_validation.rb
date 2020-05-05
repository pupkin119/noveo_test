class SlideValidation < Dry::Validation::Contract
  params do
    required(:reference).value(:string)
    required(:type).value(:string) # questionnaire precence ref, at least one content root
    required(:content).array(:hash) # do #min size 1
    #   required(:reference).filled(:string)
    #   required(:type).filled(:string) # slide req, label, one content
    #   required(:label).filled(:string)
    #
    #   required(:content).array(:hash) do # min size 1
    #     required(:reference).filled(:string)
    #     required(:type).filled(:string) # text_input, number_input, boolean, single_choice, multiple_choice
    #     required(:label).filled(:string)
    #
    #     optional(:content).array(:hash) do
    #       required(:label).filled(:string)
    #       required(:value).filled(:string)
    #     end
    #   end
    # end
  end

  rule(:content).each do # контент root
    key.failure("type slide need reference") if value["type"] == "slide" && !value["reference"].present?
    key.failure("type slide need label") if value["type"] == "slide" && !value["label"].present?

    value["content"].each do |slide| # контент для текст инпут и тд
      if slide["type"] == "text_input"
        key.failure("type text_input need reference") unless slide["reference"].present?
        key.failure("type text_input need label") unless slide["label"].present?

      elsif slide["type"] == "single_choice"
        key.failure("type single_choice need reference") unless slide["reference"].present?
        key.failure("type single_choice need label") unless slide["label"].present?
        key.failure("type single_choice need content min 1") if slide["content"].length <= 0
        slide["content"].each do |choice|
          key.failure("type single_choice in content need value") unless choice["value"].present?
          key.failure("type single_choice in content need label") unless choice["label"].present?
        end

      elsif slide["type"] == "boolean"
        key.failure("type boolean need reference") unless slide["reference"].present?
        key.failure("type boolean need label") unless slide["label"].present?

      elsif slide["type"] == "multiple_choice"
        # validates reference and label presence, and at least on response element response element validate value and label presence
        key.failure("type multiple_choice need reference") unless slide["reference"].present?
        key.failure("type multiple_choice need label") unless slide["label"].present?
        key.failure("type multiple_choice need content min size 1") if slide["content"].length <= 0
        slide["content"].each do |choice|
          key.failure("type multiple_choice in content need label") if !choice["label"].present?
          key.failure("type multiple_choice in content need value") if !choice["value"].present?
        end

      elsif slide["type"] == "number_input"
        key.failure("number_input need reference") unless slide["reference"].present?
        key.failure("number_input need label") unless slide["label"].present?
      else
        key.failure("slide have unexpected type!")
      end
    end
  end
end