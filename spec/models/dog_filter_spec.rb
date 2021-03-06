require 'rails_helper'

describe DogFilter do
  describe '.filter' do
    context 'when a manager is signed in, ' do
      let(:results) { DogFilter.filter(params: params) }

      # %w[baby young adult senior]
      context 'filter by age' do
        let!(:baby_dog) { create(:dog, :baby) }
        let!(:senior_dog) { create(:dog, :senior) }
        let(:params) { { is_age: 'baby' } }

        it 'finds the correct dog' do
          expect(results).to include(baby_dog)
          expect(results).not_to include(senior_dog)
        end
      end

      context 'filter by multiple ages' do
        let!(:baby_dog) { create(:dog, :baby) }
        let!(:senior_dog) { create(:dog, :senior) }
        let(:params) { { is_age: ['baby', 'senior'] } }

        it 'finds all matching dogs' do
          expect(results).to include(baby_dog)
          expect(results).to include(senior_dog)
        end
      end

      # ['adoptable', 'adopted', 'adoption pending', 'trial adoption',
      # 'on hold', 'not available', 'return pending', 'coming soon', 'completed']
      context 'filter by any status' do
        let!(:found_dog) { create(:dog, :completed) }
        let!(:other_dog) { create(:dog, :adoptable) }
        let(:params) { { is_status: 'completed' } }

        it 'finds the correct dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'filter by multiple statuses' do
        let!(:found_dog) { create(:dog, :completed) }
        let!(:another_found_dog) { create(:dog, :on_hold) }
        let!(:other_dog) { create(:dog, :adoptable) }
        let(:params) { { is_status: ['completed', 'on hold'] } }

        it 'finds multiple correct dogs' do
          expect(results).to include(found_dog)
          expect(results).to include(another_found_dog)
          expect(results.length).to eq 2
          expect(results).to_not include(other_dog)
        end
      end

      context 'by high_priority flag' do
        let!(:found_dog) { create(:dog, :high_priority) }
        let!(:other_dog) { create(:dog, is_high_priority: false) }
        let(:params) { { cb_high_priority: "1" } }

        it 'finds the high priority dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by medical_need flag' do
        let!(:found_dog) { create(:dog, has_medical_need: true) }
        let!(:other_dog) { create(:dog, has_medical_need: false) }
        let(:params) { { cb_medical_need: "1" } }

        it 'finds the medical_need dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by medical_review_needed flag' do
        let!(:found_dog) { create(:dog, medical_review_complete: false) }
        let!(:other_dog) { create(:dog, medical_review_complete: true) }
        let(:params) { { cb_medical_review_needed: "1" } }

        it 'finds the medical_review_needed (== !medical_review_complete) dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by special_needs flag' do
        let!(:found_dog) { create(:dog, is_special_needs: true) }
        let!(:other_dog) { create(:dog, is_special_needs: false) }
        let(:params) { { cb_special_needs: "1" } }

        it 'finds the special_needs dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by behavior_problems flag' do
        let!(:found_dog) { create(:dog, has_behavior_problem: true) }
        let!(:other_dog) { create(:dog, has_behavior_problem: false) }
        let(:params) { { cb_behavior_problems: "1" } }

        it 'finds the behaviour_problem dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by foster_needed flag' do
        let!(:found_dog) { create(:dog, needs_foster: true) }
        let!(:other_dog) { create(:dog, needs_foster: false) }
        let(:params) { { cb_foster_needed: "1" } }

        it 'finds the foster_needed dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by spay_neuter_needed flag' do
        let!(:found_dog) { create(:dog, is_altered: false) }
        let!(:other_dog) { create(:dog, is_altered: true) }
        let(:params) { { cb_spay_neuter_needed: "1" } }

        it 'finds the spay_neuter_needed ( == !is altered) dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by no_cats flag' do
        let!(:found_dog) { create(:dog, no_cats: true) }
        let!(:other_dog) { create(:dog, no_cats: false) }
        let(:params) { { cb_no_cats: "1" } }

        it 'finds the no_cats dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by no_dogs flag' do
        let!(:found_dog) { create(:dog, no_dogs: true) }
        let!(:other_dog) { create(:dog, no_dogs: false) }
        let(:params) { { cb_no_dogs: "1" } }

        it 'finds the no_dogs dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by no_kids flag' do
        let!(:found_dog) { create(:dog, no_kids: true) }
        let!(:other_dog) { create(:dog, no_kids: false) }
        let(:params) { { cb_no_kids: "1" } }

        it 'finds the no_kids dog' do
          expect(results).to include(found_dog)
          expect(results).not_to include(other_dog)
        end
      end

      context 'by breed' do
        let!(:primary_breed_dog) { create(:dog, :primary_lab) }
        let!(:secondary_breed_dog) { create(:dog, :secondary_westie) }

        it 'finds by primary breed partial match' do
          params = { is_breed: 'lab' }
          results = DogFilter.filter(params: params)
          expect(results).to include(primary_breed_dog)
          expect(results).not_to include(secondary_breed_dog)
        end

        it 'finds by secondary breed partial match' do
          params = { is_breed: 'terr' }
          results = DogFilter.filter(params: params)
          expect(results).to include(secondary_breed_dog)
          expect(results).not_to include(primary_breed_dog)
        end

      end

      context 'primary and secondary breeds both match search term' do
        let!(:primary_and_secondary_terrier) { create(:dog, :primary_and_secondary_terrier) }
        let(:params) { { is_breed: 'terr' } }
        let(:results) { DogFilter.filter(params: params) }

        it 'returns distinct results' do
          expect(results.length).to eq 1
        end
      end
    end
  end
end
