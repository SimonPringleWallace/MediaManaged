require "rails_helper"

RSpec.describe Api::V1::MovieOwnershipsController, type: :controller do
  let!(:user1) {FactoryBot.create(:user)}
  let!(:movie1) {FactoryBot.create(:movie)}

  describe "POST#create" do
    it "should create a new movie ownership" do
      new_movie_ownership = { movie_ownership: { user_rating: 5, movie_id: movie1.id } }

      sign_in(user1)

      prev_count = user1.movies.count
      post(:create, params: new_movie_ownership)
      expect(user1.movies.count).to eq(prev_count + 1)
    end

    it "should return status 201 and a success message" do
      new_movie_ownership = { movie_ownership: { user_rating: 5, movie_id: movie1.id } }

      sign_in(user1)
      post(:create, params: new_movie_ownership)

      returned_json = JSON.parse(response.body)
      expect(response.status).to eq 201
      expect(response.content_type).to eq("application/json")

      expect(returned_json["message"]).to eq("Sucessfully added #{movie1.name}!")
    end

    it "should return status 422 and errors if movie ownership not created" do
      new_movie_ownership = {movie_ownership: { user_rating: 3 }}

      sign_in(user1)
      post(:create, params: new_movie_ownership)

      returned_json = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.content_type).to eq("application/json")

      expect(returned_json["error"][0]).to eq("Movie must exist")
      expect(returned_json["error"][1]).to eq("Movie can't be blank")
    end
  end
end
