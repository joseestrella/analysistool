class GpsejemplosController < ApplicationController
  # GET /gpsejemplos
  # GET /gpsejemplos.json
  def index
    @usuarios = Usuario.all
    @usuarios_json = @usuarios.to_json
  end

  # GET /gpsejemplos/1
  # GET /gpsejemplos/1.json
  def show

  end

  # GET /gpsejemplos/new
  # GET /gpsejemplos/new.json
  def new

  end

  def edit
    @nombre = Usuario.find(params[:id]).nombre
    @gpsejemplo=Gpsejemplo.where(idUsuario: params[:id])
    @gpsejemplo_json=@gpsejemplo.to_json
  end

 def create
    @usuario=Usuario.new(params[:usuario])
    name = params[:usuario]
    nombres=Usuario.where(name)
    if nombres.length==0
      ruta = params[:ruta]
      @usuario.save
      id=@usuario.id
      if(!ruta.eql?(nil))
        arreglo=JSON.parse(ruta)
        for i in 0..arreglo["route"].length-1
          @gpsejemplo=Gpsejemplo.new(:latitude => arreglo["route"][i]["latitude"], :longitude => arreglo["route"][i]["longitude"], :timestamp => arreglo["route"][i]["timestamp"].to_s, :idUsuario => id)
          @gpsejemplo.save
        end
      end
      redirect_to gpsejemplos_path, notice: 'El usuario con su ruta fue agregado satisfactoriamente.'
    else
      redirect_to gpsejemplos_path, notice: 'El usuario ya existe en la base de datos, no se pudo agregar.'
    end
 end

  def update
    @usuario = Usuario.find(params[:id])

    # if the object saves correctly to the database
    if @usuario.update_attributes(params[:usuario])
      # redirect the user to index
      redirect_to gpsejemplos_path, notice: 'Location was successfully updated.'
    else
      # redirect the user to the edit method
      render action: 'edit'
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    @gpsejemplo=Gpsejemplo.where(idUsuario: params[:id])
    @gpsejemplo.each do |ejem|
      ejem.destroy
    end
    @usuario.destroy
    redirect_to gpsejemplos_path, notice: 'Usuario was successfully deleted.'
  end
end
