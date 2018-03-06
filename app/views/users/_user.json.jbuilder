json.(user, :id, :handle, :email)
json.token user.generate_jwt