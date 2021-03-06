require('pg')
require_relative('../db/db_runner')
require_relative('artist')


class Album

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @artist_id = options['artist_id']
    @title = options['title']
    @genre = options['genre']
  end

  def save()
    sql = "INSERT INTO albums (artist_id, title, genre) VALUES ($1, $2, $3) RETURNING id"
    values = [@artist_id, @title, @genre]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def artist
    Artist.by_id(@artist_id)
  end
  
  def self.all()
    sql = "SELECT * FROM albums"
    albums = SqlRunner.run(sql)
    return albums.map { |album| Album.new(album) }
  end

  def self.by_artist_id(artist_id)
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [artist_id]
    albums = SqlRunner.run(sql, values)
    return albums.map { |album| 
      return Album.new(album) 
    }
  end

  def self.by_title(title)
    sql = "SELECT * FROM albums WHERE title = $1"
    values = [title]
    album = SqlRunner.run(sql, values).first
    return Album.new(album)
  end

end