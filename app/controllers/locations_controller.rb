class LocationsController < ApplicationController
  def index
    # get all locations in the table locations
    @locations = Location.all

    # to json format
    @locations_json = @locations.to_json
  end

  def new
    # default: render ’new’ template (\app\views\locations\new.html.haml)
  end

  def create
    # create a new instance variable called @location that holds a Location object built from the data the user submitted
    @location = Location.new(params[:location])

    # if the object saves correctly to the database
    if @location.save
      # redirect the user to index
      redirect_to locations_path, notice: 'Location was successfully created.'
    else
      # redirect the user to the new method
      render action: 'new'
    end
  end

  def edit
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])
  end

  def update
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # if the object saves correctly to the database
    if @location.update_attributes(params[:location])
      # redirect the user to index
      redirect_to locations_path, notice: 'Location was successfully updated.'
    else
      # redirect the user to the edit method
      render action: 'edit'
    end
  end

  def destroy
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # delete the location object and any child objects associated with it
    @location.destroy

    # redirect the user to index
    redirect_to locations_path, notice: 'Location was successfully deleted.'
  end

  def bus
    @auxLat = params[:auxLat]
    @auxLon = params[:auxLon]
    @auxRad = params[:auxRad]
    @locations = Location.all
    aux=[]
    uxLat=@auxLat.to_f
    uxLon=@auxLon.to_f
    uxRad=@auxRad.to_f
    @locations.each{ |loc|
      r= 6378.137
      dLat=(loc.latitude-uxLat)*Math::PI/180
      dLong=(loc.longitude-uxLon)*Math::PI/180
      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos((uxLat)*Math::PI/180) * Math.cos((loc.latitude)*Math::PI/180) * Math.sin(dLong/2) * Math.sin(dLong/2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      d = r * c * 1000
      if(d<=uxRad)
        aux<<loc
      end
    }
    @locations=aux
    if aux.empty? && @auxLat!=nil
      @mensaje = "No se encontraron puntos de interes cercanos a los datos especificados"
    end
    @locations_json = @locations.to_json
  end

  def casco
    @locations = Location.all
    @auxLat = params[:auxLat]
    @auxLon = params[:auxLon]
    tam = @locations.length
    if tam<=3
      @mensaje="El numero de puntos de interes debe ser mayor o igual que 3, no se puede realizar calculo de casco convexo"
    else
      ordenados=[]
      cont=0
      @locations.each{|p|
        ordenados<<p
        if(cont>0)
          i=cont-1
          while(i>=0 && ordenados[i].longitude>=p.longitude)
            if(ordenados[i].longitude>p.longitude)
              ordenados[i+1]=ordenados[i]
            elsif(ordenados[i].longitude.to_f==p.longitude.to_f)
              if(ordenados[i].latitude>p.latitude)
                ordenados[i+1]=ordenados[i]
              end
            end
            i-=1
          end
          ordenados[i+1]=p
        end
        cont+=1
      }
      def cross(o, a, b)
        (a.longitude - o.longitude) * (b.latitude - o.latitude) - (a.latitude - o.latitude) * (b.longitude - o.longitude)
      end
      lower = Array.new
      ordenados.each{|p|
        while lower.length > 1 and cross(lower[-2], lower[-1], p) <= 0 do lower.pop end
        lower<<p
      }
      upper = Array.new
      ordenados.reverse_each{|p|
        while upper.length > 1 and cross(upper[-2], upper[-1], p) <= 0 do upper.pop end
        upper<<p
      }
      aux = lower[0...-1] + upper[0...-1]

      perimetro=0
      for i in 1..aux.length-1
        d=distancia(aux[i-1].latitude,aux[i-1].longitude,aux[i].latitude,aux[i].longitude)
        perimetro+=d
      end
      if(@auxLat!=nil && @auxLon!=nil)
        d=distancia(@auxLat.to_f,@auxLon.to_f,aux[0].latitude,aux[0].longitude)
        #lej=aux[0]
        for i in 1..aux.length-1
          distest=distancia(@auxLat.to_f,@auxLon.to_f,aux[i].latitude,aux[i].longitude)
          if(d<distest)
            d=distest
            #lej=aux[i]
          end
        end
        @lejano="La distancia entre la ubicacion ingresada y el punto de interes del casco convexo mas alejado es: "+d.to_s
        #@lejano_json=@lejano.to_json
      end
    end
    @peri="El perimetro del casco convexo es: "+perimetro.to_s+" metros"
    @locations=aux
    @locations_json = @locations.to_json
  end
  def distancia(lat1,long1,lat2,long2)
    r= 6378.137
    dLat=(lat1-lat2)*Math::PI/180
    dLong=(long1-long2)*Math::PI/180
    a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos((lat2)*Math::PI/180) * Math.cos((lat1)*Math::PI/180) * Math.sin(dLong/2) * Math.sin(dLong/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = r * c * 1000
    return d
  end

  def rutas
    ruta = params[:rutas]
    @locations=Location.all
    @visit=[]
    if(!ruta.eql?(nil))
      arreglo=JSON.parse(ruta)
      @locations.each{|loc|
        for i in 0..arreglo["route"].length-1
          if((loc.latitude==arreglo["route"][i]["latitude"])&&(loc.longitude==arreglo["route"][i]["longitude"]))
            @visit<<loc
          end
        end
      }
      @visit.uniq!
      if(@vist.eql?(nil))
        @mensaje="No se encontraron puntos de interes en esa ruta"
      end
      @visit_json=@visit.to_json
    end

  end

  def destroy_all
    # delete all location objects and any child objects associated with them
    Location.destroy_all

    # redirect the user to index
    redirect_to locations_path, notice: 'All locations were successfully deleted.'
  end

  def show
    # default: render ’show’ template (\app\views\locations\show.html.haml)
  end
end
