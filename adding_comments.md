# Generate the Comments
> bundle exec rails g scaffold comments description:text idea:references

# Migrate the database.

> bundle exec rake db:migrate


### Make Sure the server is running
```sh
bundle exec rails server
```

Then visit the comments page at
> http://localhost:3000/comments

###  Add the this to the in the Comment class `app/models/comment.rb`
```ruby
has_many :comments
```

### Now lets show the comments for the ideas

in `app/view/ideas/show.html.erb`

add
```html
<h3>Comments </h3>

<% @idea.comments.each do |comment| %>
  <p>
    <%= comment.description %>
    <% #= link_to 'Destroy', [@idea, comment], method: :delete, data: { confirm: 'Are you sure?' } %>
  </p>
<% end %>
```

## Now lets make it easier to add comments to an idea.


### Update the routes in `config/routes.rb`

replace

```ruby
resources :ideas
```
with

```ruby
resources :ideas do
  resources :comments
end
```

and remove 
```ruby 
  resources :comments
```

Replace all of `app/controllers/comments_controller.rb`

with

```ruby
class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # POST /comments
  # POST /comments.json
  def create
    @idea = Idea.find(params[:idea_id])
    @comment = @idea.comments.create(comment_params)
    redirect_to idea_path(@idea)
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    @idea = Idea.find(params[:idea_id])
    respond_to do |format|
      format.html { redirect_to idea_path(@idea), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:description, :idea_id)
    end
end
```

### Now lets create some new comments.

Back in `app/view/ideas/show.html.erb`

add the following
```html
<h2>Add a comment:</h2>
<%= form_with(model: [@idea, @idea.comments.build]) do |form| %>
  <p>
    <%= form.label :description %><br>
    <%= form.text_area :description %>
  </p>
  <p>
    <%= form.submit %>
  </p>
<% end %>
```


Does it work? 
Can you deploy this?
