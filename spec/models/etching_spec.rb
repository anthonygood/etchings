require 'rails_helper'

RSpec.describe Etching, :type => :model do
  let (:subject) { Etching.new( title: 'Nude Descending Stairs',
                                year: 1981,
                                width: 550,
                                height: 300,
                                plates: 2,
                                print_run: 100 ) }

  context "title" do
    it "is present" do
      expect(subject.title).to eq 'Nude Descending Stairs'
    end

    it "must be a string" do
      expect(subject).to be_valid

      subject.title = 4

      expect(subject).to be_invalid
    end

    it "saves the title" do
      subject.title = "New Title"
      subject.save!
      subject.reload

      expect(subject.title).to eq "New Title"
    end
  end

  context "year" do
    it "is a four digit number" do
      subject.year = 1981
      expect(subject).to be_valid
    end

    it "is not a string" do
      subject.year = "not a year"
      expect(subject).to be_invalid
    end

    it "is not a short or long number" do
      subject.year = 198
      expect(subject).to be_invalid

      subject.year = 19888
      expect(subject).to be_invalid
    end
  end

  context "height, width, plates, print_run" do
    it "are all integers" do
      subject.width = "Blah"
      expect(subject).to be_invalid

      subject.width = 1
      expect(subject).to be_valid

      subject.print_run = 100.1
      expect(subject).to be_invalid

      subject.print_run = 100
      expect(subject).to be_valid

      subject.plates = "three"
      expect(subject).to be_invalid

      subject.plates = 1
      expect(subject).to be_valid

      subject.height = "Blah"
      expect(subject).to be_invalid

      subject.height = 10
      expect(subject).to be_valid
    end
  end

  context "association with prints" do
    let(:association) { Etching.reflect_on_association(:prints) }

    it "is :has_many" do
      expect(association.macro).to be :has_many
    end

    it "is :dependent_destroy" do
      expect(association.options).to eq dependent: :destroy
    end
  end

  context "association with themes" do
    let(:association) { Etching.reflect_on_association(:themes) }

    it "is :has_and_belongs_many" do
      expect(association.macro).to be :has_and_belongs_to_many
    end
  end

  describe "create_with_prints" do
    let(:create_with_prints) { Etching.create_with_prints(
      title: "A Gallant Wind",
      versions: ["bizarre", "excellent"]
    ) }

    before do
      allow(Print).to receive(:create_with_image)
    end

    it "calls #create_with_image on Print", focus: true do
      expect(Print).to receive(:create_with_image).twice

      create_with_prints
    end

    it "raises an exception if you don't specify prints" do
      expect { Etching.create_with_prints }.to raise_error(ArgumentError)
    end

    context "<< integration >>" do
      before do
        allow(Print).to receive(:create_with_image).and_call_original
      end

      it "creates Print records" do
        create_with_prints
        expect(Etching.first.prints.count).to eq 2
      end

      it "appends notes to its prints" do
        create_with_prints
        expect(Etching.first.prints.first.notes).to eq "bizarre"
        expect(Etching.first.prints.last.notes).to eq "excellent"
      end
    end
  end

  describe "create_with_prints_and_themes" do
    context "<< integration >> " do
      let(:etching_with_prints_and_themes) {
        Etching.create_with_prints_and_themes(
          title: "A Gallant Wind",
          versions: ["black"],
          themes: ["Retro-futurism", "Neon"]
          )}

      before do
        allow(Print).to receive(:create_with_image).and_call_original
        allow(Etching).to receive(:create_with_prints).and_call_original
        allow(Theme).to receive(:first_or_create)
      end

      it "raises an exception if you don't specify prints" do
        expect{ Etching.create_with_prints_and_themes}.to raise_error(ArgumentError)
      end

      it "calls create_with_prints" do
        expect(Etching).to receive(:create_with_prints)
        etching_with_prints_and_themes
      end

      it "creates saves the record with its themes" do
        expect{ etching_with_prints_and_themes }.to change{ Theme.count }.by 2
      end

      it "correctly associates an etching and its themes" do
        etching_with_prints_and_themes
        expect(Theme.where(name: "Neon").first.etchings.all).to eq [etching_with_prints_and_themes]
      end
    end
  end

end
