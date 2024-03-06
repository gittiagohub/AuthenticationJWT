unit UModelUser;

interface

uses
   SimpleAttributes;

type

   [tabela('users')]
   TUser = class
   private
      Fid: integer;
      FPassword: String;
      FUserName: String;
      Fbirthdate: tdatetime;
      Fupdated_at: tdatetime;
      Fcreated_at: tdatetime;
      Fguid: string;
      Femail: String;
      Ffullname: String;
      procedure Setid(const Value: integer);
      procedure SetPassword(const Value: String);
      procedure SetUserName(const Value: String);
      procedure Setbirthdate(const Value: tdatetime);
      procedure Setcreated(const Value: tdatetime);
      procedure Setupdated(const Value: tdatetime);
      procedure Setguid(const Value: string);
      procedure Setemail(const Value: String);
      procedure Setfullname(const Value: String);

      { private declarations }
   protected
      { protected declarations }
   public
      [campo('guid'),autoinc]
      property guid: string read Fguid write Setguid;

      [campo('id'),autoinc,pk]
      property id: integer read Fid write Setid;

//      não esta retornando os campos created_at updated_at
      [campo('created_at'),autoinc]
      property created_at: tdatetime read Fcreated_at write Setcreated;

      [campo('updated_at')]
      property updated_at: tdatetime read Fupdated_at write Setupdated;

      [campo('username'), notnull]
      property username: String read FUserName write SetUserName;

      [campo('fullname'), notnull]
      property fullname: String read Ffullname write Setfullname;

      [campo('email'), notnull]
      property email: String read Femail write Setemail;

      [campo('password'), notnull]
      property password: String read FPassword write SetPassword;

      [campo('birthdate'), notnull]
      property birthdate: tdatetime read Fbirthdate write Setbirthdate;

      { public declarations }

   published
      { published declarations }
   end;

implementation

{ TUser }

procedure TUser.Setbirthdate(const Value: tdatetime);
begin
   Fbirthdate := Value;
end;

procedure TUser.Setcreated(const Value: tdatetime);
begin
   Fcreated_at := Value;
end;

procedure TUser.Setemail(const Value: String);
begin
   Femail := Value;
end;

procedure TUser.Setfullname(const Value: String);
begin
   Ffullname := Value;
end;

procedure TUser.Setguid(const Value: string);
begin
   Fguid := Value;
end;

procedure TUser.Setid(const Value: integer);
begin
   Fid := Value;
end;

procedure TUser.SetPassword(const Value: String);
begin
   FPassword := Value;
end;

procedure TUser.Setupdated(const Value: tdatetime);
begin
   Fupdated_at := Value;
end;

procedure TUser.SetUserName(const Value: String);
begin
   FUserName := Value;
end;

end.

// create  TABLE public.users (
// guid UUID not null DEFAULT uuid_generate_v4() ,
// id bigSERIAL unique not null ,
// username varchar(100) unique NOT null CHECK (username <> ''),
// fullname varchar(100)  NOT null CHECK (username <> ''),
// password varchar  NOT null CHECK (password <> ''),
// email varchar(256) unique NOT null CHECK (email <> ''),
// birthdate date  NOT null,
// created_at TIMESTAMP not null DEFAULT CURRENT_TIMESTAMP ,
// updated_at TIMESTAMP,
//  PRIMARY KEY (guid,id)
// );

// INSERT INTO Funcionarios (NomeFunc, DescrCargo)
// VALUES
// ('Monica','Pesquisadora de Novas Tecnologias na Bóson Treinamentos')
// RETURNING IdFunc;
