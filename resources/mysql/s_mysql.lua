username = get( "username" ) or "root"
password = get( "password" ) or "Vanda.0630"
db = get( "database" ) or "mtanew"
host = get( "hostname" ) or "localhost"
port = tonumber( get( "port" ) ) or 3306

function getMySQLUsername()
	return username
end

function getMySQLPassword()
	return password
end

function getMySQLDBName()
	return db
end

function getMySQLHost()
	return host
end

function getMySQLPort()
	return port
end


function lazyQuery(message)
	local filename = "/lazyqueries.log"

	
	
	local file = createFileIfNotExists(filename)
	local size = fileGetSize(file)
	fileSetPos(file, size)
	fileWrite(file, message .. "\r\n")
	fileFlush(file)
	fileClose(file)
	
	return true
end

function createFileIfNotExists(filename)
	local file = fileOpen(filename)
	
	if not (file) then
		file = fileCreate(filename)
	end
	
	return file
end