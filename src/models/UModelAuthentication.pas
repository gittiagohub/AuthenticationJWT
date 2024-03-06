unit UModelAuthentication;

interface

uses
   SimpleAttributes;

type

   [tabela('users_token')]
   TUserToken = class
   private
      Fid: integer;
      FupdatedAt: tdatetime;
      FcreatedAt: tdatetime;
      Fguid: string;
      FexpiryAt: tdatetime;
      FidUsers: integer;
      Ftoken: string;
      Fativo: integer;

      procedure Setid(const Value: integer);
      procedure Setcreated(const Value: tdatetime);
      procedure Setupdated(const Value: tdatetime);
      procedure Setguid(const Value: string);
      procedure SetexpiryAt(const Value: tdatetime);
      procedure SetidUsers(const Value: integer);
      procedure Settoken(const Value: string);
      procedure Setativo(const Value: integer);

      { private declarations }
   protected
      { protected declarations }
   public
      [campo('guid'), ignore]
      property guid: string read Fguid write Setguid;

      [campo('id'), autoinc,pk]
      property id: integer read Fid write Setid;

      [campo('created_at'), autoinc]
      property createdAt: tdatetime read FcreatedAt write Setcreated;

      [campo('updated_at')]
      property updatedAt: tdatetime read FupdatedAt write Setupdated;

      [campo('expiry_at'), notnull]
      property expiryAt: tdatetime read FexpiryAt write SetexpiryAt;

      [campo('id_users'), notnull]
      property idUsers: integer read FidUsers write SetidUsers;

      [campo('token'), notnull]
      property token: string read Ftoken write Settoken;

      [campo('ativo'), notnull]
      property ativo: integer read Fativo write Setativo;

      { public declarations }
   published
      { published declarations }
   end;

implementation

{ TUser }

procedure TUserToken.Setativo(const Value: integer);
begin
   Fativo := Value;
end;

procedure TUserToken.Setcreated(const Value: tdatetime);
begin
   FcreatedAt := Value;
end;

procedure TUserToken.SetexpiryAt(const Value: tdatetime);
begin
   FexpiryAt := Value;
end;

procedure TUserToken.Setguid(const Value: string);
begin
   Fguid := Value;
end;

procedure TUserToken.Setid(const Value: integer);
begin
   Fid := Value;
end;

procedure TUserToken.SetidUsers(const Value: integer);
begin
   FidUsers := Value;
end;

procedure TUserToken.Settoken(const Value: string);
begin
   Ftoken := Value;
end;

procedure TUserToken.Setupdated(const Value: tdatetime);
begin
   FupdatedAt := Value;
end;

end.

// create  TABLE public.users_token (
// guid UUID not null DEFAULT uuid_generate_v4() ,
// id bigSERIAL unique not null ,
// id_users  bigint not null,
// token varchar,
// expiry_at TIMESTAMP not null  ,
// created_at TIMESTAMP not null DEFAULT CURRENT_TIMESTAMP ,
// updated_at TIMESTAMP ,
// PRIMARY KEY (guid,id),
// FOREIGN KEY (id_users) REFERENCES users(id)
// );
