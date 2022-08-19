require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe '/posts/new' do
    it 'success' do
      get new_post_path

      expect(response).to have_http_status(:success)
    end
  end

  describe '/posts/create' do
    def create_post(title, body)
      post posts_path, params: {
        post: {
          title:,
          body:
        }
      }
    end

    context 'valid parameters' do
      it 'successfully create a post' do
        expect { create_post('example title', 'example body') }.to change { Post.count }.from(0).to(1)

        expect(response).to have_http_status(:redirect)
      end
    end

    context 'invalid parameters' do
      it 'fails to create a post' do
        expect { create_post('', '') }.not_to change { Post.count }

        expect(Post.count).to eq(0)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '/posts/:id for show' do
    let(:post) { create(:post) }

    context 'when passing in valid post id' do
      it 'successfully shows the post with id' do
        get post_path(post)

        expect(response).to have_http_status(:success)
      end
    end

    context 'when passing in invalid post id' do
      it 'fails to show the post with id' do
        expect { get post_path('teststtss') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
