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

  describe '/posts/:id/edit for edit' do
    let(:post) { create(:post) }

    it 'successfully edit the post with id' do
      get edit_post_path(post)

      expect(response).to have_http_status(:success)
    end
  end

  describe '/posts/:id/edit for update' do
    let(:post) { create(:post) }

    context 'when it is a valid update' do
      it 'updates' do
        old_title = post.title
        new_title = 'Update title'

        expect do
          put post_path(post), params: {
            post: {
              title: new_title
            }
          }
        end.to change { post.reload.title }.from(old_title).to(new_title)

        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when it is a invalid update' do
      it 'fails to update' do
        expect do
          put post_path(post), params: {
            post: {
              title: ''
            }
          }
        end.not_to change { post.reload.title }

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '/posts/:id/delete for delete' do
    let(:post) { create(:post) }

    it 'successfully delete the post' do
      delete post_path(post)
      expect { Post.find(post.id) }.to raise_error(ActiveRecord::RecordNotFound)

      expect(response).to have_http_status(:redirect)
    end
  end
end
